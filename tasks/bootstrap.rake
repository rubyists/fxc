tbl = Dir['twitter_boostrap/lib/*.less']

tbl.each do |path|
  file path do
  end
end

file 'public/css/bootstrap.css' => tbl do
  p tbl
end

task :bootstrap => ['public/css/bootstrap.css'] do
end
