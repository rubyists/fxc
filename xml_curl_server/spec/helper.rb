require_relative '../app'
require 'nokogiri'
require 'innate/spec/bacon'

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

Innate::Log.loggers = []
