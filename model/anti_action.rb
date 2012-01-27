class FXC::AntiAction < Sequel::Model
  set_dataset FXC.db[:fs_anti_actions]
  many_to_one :condition, :class => 'FXC::Condition'
  plugin :list, :scope => :condition_id

  protected
  def before_create
    unless self[:position]
      self[:position] = last_position + 1
    end
  end
end
