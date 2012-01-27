class FXC::Extension < Sequel::Model
  set_dataset FXC.db[:fs_extensions]
  one_to_many :conditions, :class => 'FXC::Condition'
  many_to_one :context, :class => 'FXC::Context'
  plugin :list, :scope => [:context_id, :user_id]

  def self.match(context_id, params)
    all = FXC::Extension.filter(:context_id => context_id).all
    return nil unless all
    fs_params = {}
    params.each do |key, value|
      case key
      when /^variable_(.*)/
        fs_params[$1.downcase] = value
      when /^Caller-(.*)/
        fs_params[$1.downcase.tr("-","_")] = value
      else
        fs_params[key.downcase.tr("-", "_")] = value
      end
    end

    match_select(all, fs_params)
  end

  def self.match_select(matches, params)
    matches.select do |exten|
      # We only match the first condition
      # Should match subesquent conditions until failure
      # break=never|on-true|on-false affect this

      next true if exten.continue
      next false unless condition = exten.conditions.first
      next true unless condition.matcher
      next true if condition.break == "never"
      good = true
      exten.conditions.each { |cond|
        unless check_condition(cond, params)
          Innate::Log.debug "#{cond.inspect} didn't match #{params}"
          break(good = false)
        end
      }
      Innate::Log.debug "<< #{good} >>"
      good
    end
  end

  def self.check_condition(condition, params)
    case condition.matcher
    when /^\$\{(\w+)\}$/, /^(\w+)$/ # only normal variables
      Innate::Log.debug "Matcher is #{condition.matcher}, Expression is #{condition.expression}: (#{params[$1]})"
      params[$1] =~ %r{#{condition.expression}}
    else # benefit of the doubt
      Innate::Log.debug "Matcher is #{condition.matcher}, params are #{params}, defaulting to true"
      true
    end
  end

  @scaffold_human_name = 'Extensions'
  @scaffold_column_types = {
    :name => :string,
    :description => :string,
    :context => :string
  }

  def scaffold_name
    "#{context} (#{name})"
  end

  protected
  def before_create
    self[:context_id] = Context.default.id unless self[:context_id]
    self[:position] = if (max = Extension.find(user_id: self[:user_id], context_id: self[:context_id]).order(:position.desc))
                        max.position + 1
                      else
                        1
                      end
  end

end
