require 'json'
require "ramaze"

require_relative "lib/fxc"

require_relative "options"

require_relative 'controller/main'
require_relative 'controller/context'
require_relative 'controller/super_admin'
require_relative 'controller/admin'

require_relative 'model/init'

if $0 == __FILE__
  Ramaze.start file: __FILE__
end
