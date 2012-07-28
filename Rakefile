require "rubygems/package_task"
require "rake/testtask"

load(File.join(File.dirname(__FILE__), "gatling_gun.gemspec"))
Gem::PackageTask.new(SPEC) do |package|
  # do nothing:  I just need a gem but this block is required
end

Rake::TestTask.new do |test|
  test.libs       << "test"
  test.test_files =  %w[test/*.rb]
  test.verbose    =  true
end