require 'pathname'

class Pathname
  def /(other)
    join(other.to_s)
  end
end

module FXC
  ROOT = Pathname(File.expand_path('../../', __FILE__))
  LIBROOT = ROOT/:lib
  MIGRATION_ROOT = ROOT/:db/:migrate
  MODEL_ROOT = ROOT/:model
  SPEC_HELPER_PATH = ROOT/:spec
  def self.load_fsr
    require "fsr"
  rescue LoadError
    require "rubygems"
    require "fsr"
  end
end
