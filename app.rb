require 'json'
require "ramaze"

require_relative "lib/fxc"

require_relative "options"

require_relative 'node/main'
require_relative 'node/context'

require_relative 'model/init'

if $0 == __FILE__
  Ramaze.start file: __FILE__
end
