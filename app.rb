require 'json'
require "ramaze"

require_relative "lib/fxc"
require_relative "lib/fxc/websocket"

require_relative "options"

require_relative 'controller/init'
require_relative 'model/init'

if $0 == __FILE__
  require 'thin'
  require 'em-websocket'

  EM.epoll?
  EM.run do
    Ramaze.start file: __FILE__, started: true
    Thin::Server.start Ramaze, 'localhost', 9192
    FXC::WebSocket.start host: '127.0.0.1', port: 9193, debug: false do |c|
      c.models(
        FXC::Context,
        FXC::Context::Collection
      )
    end
  end
end
