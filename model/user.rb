require_relative '../lib/fxc'
require_relative '../lib/fxc/dialstring'
require "digest/sha1"

module FXC
  class User < Sequel::Model
    set_dataset FXC.db[:users]
    one_to_many :variables, :class => 'FXC::UserVariable'
    one_to_many :targets, :class => 'FXC::Target'
    one_to_many :dids, :class => 'FXC::Did'
    many_to_one :context, :class => 'FXC::Context'
    one_to_many :extensions, class: 'FXC::Extension'

    @scaffold_human_name = 'User'
    @scaffold_column_types = {
      :cidr => :string,
      :email => :string,
      :first_name => :string,
      :last_name => :string,
      :timezone => :string,
      :mailbox => :string,
      :dialstring => :string,
      :password => :string,
    }
    def params
      {
        'dial-string' => dialstring,
        'password' => pin,
        'vm-password' => pin
      }
    end

    def add_time_of_day_rule(time_min, time_max, day_min = 0, day_max = 6, actions = [])
      tod_string = "%s-%s:%s-%s" % [day_min, day_max, time_min, time_max]
      e = add_extension(name: "#{extension} - TOD:#{tod_string}")
      cond = e.add_condition(minute_of_day: "#{time_min}-#{time_max}", wday:"#{day_min}-#{day_max}", matcher: "destination_number", expression: %r{^#{extension}$}.to_s)
      actions.each { |action|
        p action
        if action[:action] == :dial
          if action[:numbers].size == 1
            cond.add_action(
              application: "transfer",
              data: "#{action[:numbers].first} XML default"
            )
          else
            ds = action[:numbers].map { |n| "sofia/internal/#{n}" }
            cond.add_actions(application: "bridge", data: ds.join(","))
          end
        end
      }
      e.reload
    end

    TOD_MATCH = %r{TOD:(\w+)-(\w+):(\d+)-(\d+)$}

    def time_of_day_routing_rules
      extensions.select { |e| e.name =~ TOD_MATCH }
    end

    def scaffold_name
      "#{display_name} (#{username})"
    end

    def fullname
      self[:fullname] || [first_name, last_name].join(" ")
    end

    def caller_id_number
      if cid = variables.detect { |n| n.name == "effective_caller_id_number" }
        cid.value
      else
        extension
      end
    end

    def caller_id_name=(other)
      if cid = variables.detect { |n| n.name == "effective_caller_id_name" }
        cid.update(value: other)
      else
        add_variable(name: "effective_caller_id_name", value: other)
      end
    end

    def caller_id_name
      if cid = variables.detect { |n| n.name == "effective_caller_id_name" }
        cid.value
      else
        caller_id_number
      end
    end

    def dialstring
      pk ? FXC::Dialstring.new(self, targets).to_s : ''
    end

    def default_variables
      @_d_v ||= [
        [:user_context, :default],
        [:accountcode, username],
        [:toll_allow, "domestic,international,local"],
        [:effective_caller_id_number, username],
        [:effective_caller_id_name, fullname]
      ]
    end

    def set_default_variables
      update(:mailbox => extension) if mailbox.nil?
      FXC::Context.default.add_user(self) if context.nil?
      default_variables.each do |var|
        name, value = var.map { |s| s.to_s }
        if current = variables.detect { |d| d.name == name }
          current.value = value
          current.save
        else
          add_variable(FXC::UserVariable.new(:name => name, :value => value))
        end
      end
    end

    def self.from_extension(ext,_)
      find(extension: ext, active: true)
    end

    def self.active_users
      filter(:active => true)
    end

    # auth related stuff
    #
    # id may be email or username, but password has to be given for either.
    def self.authenticate(creds)
      id, password = creds.values_at(:id, :password)
      filter({:username => id} | {:email => id}).
        and(:password => digestify(password)).limit(1).first
    end

    def self.digestify(pass)
      Digest::SHA1.hexdigest(pass.to_s)
    end

    def password=(other)
      values[:password] = ::FXC::User.digestify(other)
    end

    def self.extension_gaps
      FXC.db[:users___m].
        left_join(:users___r, :m__extension.cast(:integer)=>(:r__extension.cast(:integer) - 1)).
        filter(:r__extension=>nil).
        select{[(m__extension.cast(:integer)+1).as(start),
                FXC.db[:users___x].select{:min.sql_function(extension.cast(:integer) - 1).cast(:text)}.
                filter{x__extension>m__extension}.as(stop)]}.
        from_self(:alias=>:x).exclude(:stop=>'').select(:start, :stop)
    end

    def self.max_extension
      FXC.db[:users].select(:max.sql_function(:extension).as(:ext)).order(:ext.desc).limit(1)
    end

    def self.next_extension
      if gap = extension_gaps.first
        return gap[:start]
      else
        if last = max_extension.first
          (last[:ext].to_i + 1).to_s
        else
          raise "No extensions available!"
        end
      end
    end

    def create_default_route
      ext = FXC::Extension.find_or_create(user_id: self[:id], name: "#{extension} - #{fullname}", context_id: FXC::Context.default.id)
      current = ext.conditions.detect { |m| m.matcher == "destination_number" && m.expression == "^#{extension}$" }
      return current if current
      cond = ext.add_condition(matcher: "destination_number", expression: "^#{extension}$")
      cond.add_action(application: "set", data: "continue_on_fail=true")
      cond.add_action(application: "set", data: "hangup_after_bridge=true")
      cond.add_action(application: "bridge", data: "user/#{extension}")
      cond.add_action(application: "answer")
      cond.add_action(application: "sleep", data: "1000")
      cond.add_action(application: "bridge", data: "loopback/app=voicemail:default ${domain_name} #{mailbox || extension}")
      cond
    end

    def set_security_defaults
      self[:pin] = generate_pin unless self[:pin]
      self[:password] = self[:pin] unless self[:password]
      self[:username] = self[:extension] unless self[:username]
      self.save
    end

    def generate_pin
      "%d" % ((rand * 900000) + 9999)
    end

    protected
    def after_create
      set_default_variables
      create_default_route
      set_security_defaults
    end

    def validate
      if new?
        self[:extension] = User.next_extension if (self[:extension].nil? || self[:extension].empty?)
        self[:mailbox] ||= self[:extension]
        #@errors.add(:extension, "can not be directly assigned above 3175") if extension and extension.to_i > 3175
      end
      if me = FXC::User[:extension => extension]
        @errors.add(:extension, "can not be duplicated") unless self[:id] and me[:id] == self[:id]
      end
      if username and my_user = FXC::User[:username => username]
        @errors.add(:username, "can not be duplicated") unless self[:id] and my_user[:id] == self[:id]
      end
      @errors.add(:email, "must be a valid email address") unless email.to_s.match(/^(?:[^@\s]+?@[^\s@]{6,})?$/)
      @errors.add(:pin, "must be all digits (4 minimum)") unless pin.to_s.match(/^(?:\d\d\d\d+)?$/)
      @errors.add(:extension, "must be all digits") unless self[:extension] =~ /^(\d+)$/
      @errors.add(:mailbox, "must be all digits") unless mailbox =~ /^(?:\d+)$/
    end
  end
end
