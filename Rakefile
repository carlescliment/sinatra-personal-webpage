require 'rubygems'
require 'rspec/core/rake_task'

desc "Run server"
task :serverup do
    system "ruby app.rb"
end

namespace :test do

    desc "Run model specs"
    RSpec::Core::RakeTask.new(:model) do |t|
        t.pattern = "spec/model/*.rb"
        t.rspec_opts = " -c"
    end

    desc "Run functional specs"
    RSpec::Core::RakeTask.new(:functional) do |t|
        t.pattern = "spec/functional/*.rb"
        t.rspec_opts = " -c"
    end

    desc "Run controller specs"
    RSpec::Core::RakeTask.new(:controller) do |t|
        t.pattern = "spec/controller/*.rb"
        t.rspec_opts = " -c"
    end

    desc "Run all specs"
    task :all do
        Rake::Task['test:model'].execute
        Rake::Task['test:controller'].execute
        Rake::Task['test:functional'].execute
    end

end