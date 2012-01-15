task compile: [:compile_compass, :compile_coffee]

task :compile_compass do
  sh 'compass compile -c src/compass_config.rb'
end

task :compile_coffee do
  sh 'coffee -o public/js src/cs/*.coffee'
end

task :watch do
  compass = fork{ sh 'compass watch -c src/compass_config.rb' }
  coffee = fork{ sh 'coffee -w -o public/js src/cs/*.coffee' }

  trap(:INT){
    Process.kill(15, compass)
    Process.kill(15, coffee)
  }
  Process.waitpid(coffee)
end
