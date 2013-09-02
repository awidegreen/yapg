$:.unshift(File.dirname(__FILE__))

require 'rake/testtask'

task :default => :test

# need to touch Gemfile.lock as bundle doesn't touch the file if there is no change
file "Gemfile.lock" => "Gemfile" do
  sh "bundle && touch Gemfile.lock"
end

desc "Test yapg, especially lib"
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = Dir.glob("test/**/*_test.rb")
  t.verbose = true
end

