module FXC
  class User
    include Makura::Model

    defaults['type'] = 'user'

    properties(
      :buttons, :domain, :gateways, :groups, :id, :params, :server, :variables,
      :targets, :cidr, :mailbox
    )

    def self.view_user_common(view, id, server = nil)
      if server
        query = {key: [id, server], limit: 1}
      else
        query = {startkey: [id], endkey: [id, {}], limit: 1}
      end

      query.merge!(limit: 1, include_docs: true)
      Innate::Log.debug(query: query, view: view)
      row = database.view(view, query)['rows'].first
      Innate::Log.debug(row: row)
      doc = row['doc'] if row
      new(doc) if doc
    end

    def self.view_user(id, server = nil)
      view_user_common('directory/_view/users', id, server)
    end

    def self.view_active_user(id, server = nil)
      view_user_common('directory/_view/active_users', id, server)
    end

    def self.from_extension(extension, server = nil)
      view_user(extension, server)
    end

    def self.active_from_extension(extension, server = nil)
      view_active_user(extension, server)
    end

    def self.active_users
      rows = database.view('directory/_view/active_users', include_docs: true)['rows']
      rows.map do |row|
        doc = row['doc']
        new(doc) if doc
      end.compact
    end

    def dialstring
      (targets || {}).group_by{|name, properties|
        properties['priority']
      }.map{|priority, values|
        values.map(&:first).join(',')
      }.join('|')
    end

    def add_target(name, priority = 1, type = 'landline')
      priority, type = priority.to_i, type.to_s.strip
      raise ArgumentError, "priority must be > 0" unless priority > 0
      raise ArgumentError, "type cannot be empty" if type.empty?

      self.targets ||= {}
      targets[name] = {priority: priority, type: type}
    end
  end
end

__END__
# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
require File.expand_path("../../lib/fxc", __FILE__)
require FXC::ROOT/:lib/:fxc/:dialstring
require "digest/sha1"
class FXC::User < Sequel::Model(FXC.db[:users])
  one_to_many :user_variables, :class => 'FXC::UserVariable'
  one_to_many :targets, :class => 'FXC::Target'
  one_to_many :dids, :class => 'FXC::Did'
  many_to_one :context, :class => 'FXC::Context'

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

  def scaffold_name
    "#{display_name} (#{username})"
  end

  def fullname
    [first_name, last_name].join(" ")
  end

  def dialstring
    pk ? FXC::Dialstring.new(self, targets, '').to_s : ''
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
      if current = user_variables.detect { |d| d.name == name }
        current.value = value
        current.save
      else
        add_user_variable(FXC::UserVariable.new(:name => name, :value => value))
      end
    end
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

  protected
  def after_create
    set_default_variables
  end

  def validate
    if new?
      @errors.add(:extension, "can not be directly assigned above 3175") if extension and extension > 3175
    end
    if me = FXC::User[:extension => extension]
      @errors.add(:extension, "can not be duplicated") unless self[:id] and me[:id] == self[:id]
    end
    if username and my_user = FXC::User[:username => username]
      @errors.add(:username, "can not be duplicated") unless self[:id] and my_user[:id] == self[:id]
    end
    @errors.add(:email, "must be a valid email address") unless email.to_s.match(/^(?:[^@\s]+?@[^\s@]{6,})?$/)
    @errors.add(:pin, "must be all digits (4 minimum)") unless pin.to_s.match(/^(?:\d\d\d\d+)?$/)
    @errors.add(:extension, "must be all digits (4 minimum)") unless extension.to_s.match(/^(?:\d\d\d\d+)?$/)
    @errors.add(:mailbox, "must be all digits (4 minimum)") unless mailbox.to_s.match(/^(?:\d\d\d\d+)?$/)
  end
end
