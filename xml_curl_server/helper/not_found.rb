module Innate
  module Helper
    module NotFound
      def not_found
        body = FXC::Proxy.render_view(:not_found)
        respond(body, 200, 'Content-Type' => 'freeswitch/xml')
      end
    end
  end
end
