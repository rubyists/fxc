desc 'Setup postgresl database'
task :spec_setup do
  require 'uri'
  require 'shellwords'
  require 'pgpass'

  db = ENV['FXC_DB'] || Pgpass.match(username: Etc.getlogin)
  if db.nil?
    warn "please set FXC_DB or create a .pgpass for #{Etc.getlogin}"
    warn "to set the FXC_DB variable, you can do something like:"
    warn "export FXC_DB=postgres://user:pass@host/dbname"
    warn "more details on pgpass at http://www.postgresql.org/docs/current/static/libpq-pgpass.html"
    exit 1
  end

  uri = URI(db)
  case uri.scheme
  when 'postgres'
    db_name = uri.path.split('/').last
    sh "dropdb -U postgres #{db_name.shellescape}" do |success|
      puts "Failed to dropdb #{db_name}" unless success
    end
    sh "createdb -U postgres #{db_name.shellescape}"
  else
    raise NotImplementedError, 'only postgresql supported right now'
  end

  Rake::Task[:migrate].execute
end

task :spec_run do
  Dir.glob('spec/{fxc,model,view}/**/*.rb') do |path|
    sh FileUtils::RUBY, path
  end
end

task spec: [:spec_setup, :spec_run]
task default: [:spec]
