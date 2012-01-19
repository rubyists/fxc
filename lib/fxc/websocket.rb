require 'em-websocket'

module FXC
  class WebSocket < EventMachine::WebSocket::Connection
    def self.start(options, &block)
      EM.epoll
      EM.run do
        EventMachine.start_server(
          options[:host], options[:port],
          FXC::WebSocket, options, &block
        )
      end
    end

    def initialize(*args)
      @backbone_models = {}
      super
    end

    def models(*objs)
      objs.each do |obj|
        @backbone_models[obj.name] = obj
      end
    end

    def trigger_on_message(json_encoded)
      msg = JSON.parse(json_encoded)
      Log.debug msg: msg

      frame = msg['frame']
      method, url, id, attributes =
        msg['body'].values_at('method', 'url', 'id', 'attributes')

      handler = @backbone_models.fetch(url)
      response =
        case method
        when 'create'; handler.backbone_create(attributes)
        when 'read';   handler.backbone_read(id)
        when 'update'; handler.backbone_update(id, attributes)
        when 'delete'; handler.backbone_delete(id)
        else; raise "Unknown method %p in %p" % [method, msg]
        end

      say frame: frame, ok: response
    rescue => error
      Log.error(error)
      say frame: frame, error: error.to_s
    end

    def say(obj)
      Log.info say: obj
      send(obj.to_json)
    end
  end
end
