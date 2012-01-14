require_relative '../lib/fxc'
require_relative '../options'
require_relative '../lib/fxc/db'
raise "No DB Available" unless FXC.db

# Here go your requires for models:
require_relative 'user'
require_relative 'user_variable'
require_relative 'target'
require_relative 'did'
require_relative 'provider'
require_relative 'server'
require_relative 'context'
require_relative 'voicemail'
# require "sequel_orderable"
require_relative 'extension'
require_relative 'condition'
require_relative 'action'
require_relative 'anti_action'
# require_relative 'configuration'
