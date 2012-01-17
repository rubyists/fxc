task 'compile compass and coffee files'
task compile: [:compile_compass, :compile_coffee]

task :compile_compass do
  sh 'compass compile -c src/compass_config.rb'
end

task :compile_coffee do
  sh 'coffee -o public/js src/cs/*.coffee'
end

desc 'watch and compile the changes to compass or coffee files'
task :watch do
  compass = fork{ sh 'compass watch -c src/compass_config.rb' }
  coffee = fork{ sh 'coffee -w -o public/js src/cs/*.coffee' }

  trap(:INT){
    Process.kill(15, compass)
    Process.kill(15, coffee)
  }
  Process.waitpid(coffee)
end
