require "innate"
require_relative "lib/fxc"
require_relative "options"
require_relative 'node/proxy'

require FXC::ROOT/"model/init"
require FXC::ROOT/"lib/rack/middleware"

Innate::Response.options.headers['Content-Type'] = 'freeswitch/xml'
Innate.options.roots = [FXC::ROOT.to_s]
Innate.options.publics = ['/public']

Innate.middleware! do |mw|
  mw.use FXC::Rack::Middleware
  mw.use Rack::Head
  mw.use Rack::ContentLength
  mw.use Rack::ShowExceptions
  mw.use Rack::CommonLogger, Innate::Log
  mw.use Rack::ShowStatus
  mw.use Rack::ConditionalGet
  mw.innate
end

if $0 == __FILE__
  Innate.start :root => FXC::ROOT.to_s, :file => __FILE__
end
