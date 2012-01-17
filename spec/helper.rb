require_relative '../app'
require 'nokogiri'
require 'ramaze/spec/bacon'

Ramaze::Log.loggers = [
  Logger.new(File.expand_path('log/innate.log', FXC::ROOT))
]

Ramaze.options.roots = [FXC::ROOT]
