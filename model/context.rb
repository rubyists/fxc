module FXC
  class Context < Sequel::Model
    set_dataset FXC.db[:dialplan_contexts]

    plugin :json_serializer

    one_to_many :users, :class => 'FXC::User'
    one_to_many :dids, :class => 'FXC::Did'
    one_to_many :extensions, :class => 'FXC::Extension'
    one_to_many :gateways, :class => 'FXC::SipGateway', :key => :dialplan_context_id
    many_to_one :domains, :class => 'FXC::Domain'

    def self.default
      find_or_create(:name => "default")
    end

    def self.public
      find_or_create(:name => "public")
    end

    module Collection
      module_function

      def backbone_create
      end

      def backbone_read(id)
        Context.all
      end

      def backbone_update
      end

      def backbone_delete
      end
    end
  end
end
