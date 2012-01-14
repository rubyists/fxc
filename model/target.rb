class FXC::Target < Sequel::Model
  set_dataset FXC.db[:targets]
  many_to_one :user, :class => 'FXC::User'
  many_to_one :did, :class => 'FXC::Did'

  @scaffold_human_name = 'Target'
  @scaffold_column_types = {
    :type => :string,
    :value => :string,
  }

  def dialstring
    value
  end
end
