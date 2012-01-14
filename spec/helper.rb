require File.expand_path('../../app', __FILE__)
require 'nokogiri'
require 'innate/spec/bacon'
Innate::Log.loggers = [Logger.new(FXC::ROOT/:log/"innate.log")]
Innate.middleware! :spec do |m|
  m.use Rack::Lint
  m.use Rack::CommonLogger, Innate::Log
  m.use FXC::Rack::Middleware
  m.innate
end

Innate.options.roots = [FXC::ROOT]
