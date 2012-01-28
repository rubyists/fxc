require 'innate'
require 'ramaze'
require 'pgpass'

require_relative '../options'

require_relative 'lib/rack_middleware'

require_relative '../model/init'

require_relative 'node/proxy'
require_relative 'node/directory'
require_relative 'node/dialplan'

Innate::Response.options.headers['Content-Type'] = 'freeswitch/xml'
Innate.options.roots = [File.expand_path('../', __FILE__)]

Innate.middleware! do |m|
  m.use Rack::ShowExceptions
  m.use FXC::RackMiddleware
  m.use Rack::Head
  m.use Rack::ContentLength
  m.use Rack::CommonLogger, Innate::Log
  m.use Rack::ShowStatus
  m.use Rack::ConditionalGet
  m.innate
end
