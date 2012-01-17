require 'fsr'
require 'pgpass'
require 'sequel'

module FXC
  class Pathname < ::Pathname
    def /(other)
      join(other.to_s)
    end
  end

  ROOT = File.expand_path('../../', __FILE__)
  MIGRATION_ROOT = File.expand_path('db/migrate', ROOT)

  @db ||= nil

  def self.db
    @db ||= Sequel.connect(FXC.options.db)
  end

  def self.db=(other)
    @db = Sequel.connect(other)
  end
end
