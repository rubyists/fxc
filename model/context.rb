class FXC::Context < Sequel::Model
  set_dataset FXC.db[:dialplan_contexts]

  one_to_many :users, :class => 'FXC::User'
  one_to_many :dids, :class => 'FXC::Did'
  one_to_many :extensions, :class => 'FXC::Extension'
  one_to_many :gateways, :class => 'FXC::SipGateway', :key => :dialplan_context_id
  many_to_one :domains, :class => 'FXC::Domain'

  @scaffold_human_name = 'DID Context'
  @scaffold_column_types = {
    :description => :string
  }

  def self.default
    find_or_create(:name => "default")
  end

  def self.public
    find_or_create(:name => "public")
  end
end
