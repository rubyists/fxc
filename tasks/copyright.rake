require "pathname"

file 'LICENSE' do
  File.open('LICENSE', 'w+') do |io|
    io.puts PROJECT_COPYRIGHT
  end
end

file 'doc/LEGAL' do
  File.open('doc/LEGAL', 'w+') do |io|
  end
end

desc "add copyright summary to all .rb files in the distribution"
task :copyright => ['LICENSE', 'doc/LEGAL'] do
  ignore = File.readlines('doc/LEGAL').
    map{|line| Pathname(line.strip).expand_path }.
    select(&:file?)

  puts "adding copyright summary to files that don't have it currently"
  puts PROJECT_COPYRIGHT_SUMMARY
  puts

  [ '{controller,model,app,lib,test,spec,migrations}/**/*{.rb}',
    'tasks/*.rake', 'Rakefile',
  ].each do |glob|
    Pathname.glob(glob) do |file|
      ensure_copyright(file)
    end
  end
end

def ensure_copyright(file)
  file.open 'r+' do |io|
    line = io.gets.chomp

    case line
    when PROJECT_COPYRIGHT_SUMMARY
      return
    when /^#/
      head = []
      begin
        head << line
        line = io.gets.chomp
      end while line =~ /^#|^\s*$/

      original = io.read
      io.truncate(0)
      io.puts(PROJECT_COPYRIGHT_SUMMARY)
      io.write(original)
    else
      io.rewind
      original = io.read
      io.truncate(0)
      io.puts(PROJECT_COPYRIGHT_SUMMARY)
      io.write(original)
    end
  end
end
