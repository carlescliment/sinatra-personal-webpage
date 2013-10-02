require 'rubygems'
require 'rspec/core/rake_task'


desc "Run server"
task :serverup do
    system "ruby app.rb"
end

namespace :test do

    desc "Run functional tests"
    RSpec::Core::RakeTask.new(:functional) do |t|
        t.pattern = "test/functional/*.rb"
        t.rspec_opts = " -c"
    end

    desc "Run all tests"
    task :all do
        Rake::Task['test:functional'].execute
    end

end