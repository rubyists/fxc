desc 'Setup postgresl database'
task :spec_setup do
  require 'uri'
  require 'shellwords'

  db = ENV['FXC_DB'] ||= 'postgres://callcenter@localhost/fxc_spec'
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
