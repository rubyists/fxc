class FXC::Server < Sequel::Model
  set_dataset FXC.db[:servers]
  one_to_many :contexts, :class => 'FXC::Context'
end
