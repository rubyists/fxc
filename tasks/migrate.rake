desc "migrate to latest version of db"
task :migrate, :version do |_, args|
  args.with_defaults(:version => nil)

  require_relative '../lib/fxc'
  require_relative '../options'
  require 'sequel/extensions/migration'

  if $VERBOSE
    FXC.db.loggers << Logger.new($stdout)
  end

  raise "No DB found" unless FXC.db
  warn FXC.db.inspect

  require_relative "../model/init"

  if /(?<version>\d+)/ =~ args.version
    Sequel::Migrator.run(FXC.db, FXC::MIGRATION_ROOT, target: version.to_i)
  else
    Sequel::Migrator.apply(FXC.db, FXC::MIGRATION_ROOT)
  end
end

