class FXC::UserVariable < Sequel::Model
  set_dataset FXC.db[:user_variables]
  many_to_one :user, :class => 'FXC::User'

  @scaffold_human_name = 'User Variable'
  @scaffold_column_types = {
    :name => :string,
    :value => :string,
  }

  def scaffold_name
    "#{name}: #{value}"
  end

  def to_s
    name.to_s
  end
end
