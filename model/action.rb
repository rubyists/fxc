class FXC::Action < Sequel::Model
  set_dataset FXC.db[:fs_actions]
  many_to_one :condition, :class => 'FXC::Condition'
  plugin :list, :scope => :condition_id

  def dialstring
    case data
    when /^(\d+)\sXML/
      "Transfer to %s" % $1
    when %r{\w+/.*/(\d+)}
      "Dial %s" % $1
    else
      data
    end
  end

  protected

  def before_create
    unless self[:position]
      if max = last_position
        self[:position] = max + 1
      else
        self[:position] = 1
      end
    end
  end
end
