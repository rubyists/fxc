#!/usr/bin/env rackup

require ::File.expand_path('app', ::File.dirname(__FILE__))
Innate.start(:file => __FILE__, :started => true)
run Innate
