require "bundler/gem_tasks"
require 'ci/reporter/test_utils/rake'
include CI::Reporter::TestUtils::Rake

namespace :generate do
  task :clean do
    rm_rf "acceptance/reports"
  end

  task :spinach do
    spinach = "#{Gem.loaded_specs['spinach'].gem_dir}/bin/spinach"
    run_ruby_acceptance "-I../../lib -rci/reporter/rake/spinach_loader -S #{spinach} -r ci_reporter -f acceptance/spinach/features"
  end

  task :all => [:clean, :spinach]
end

task :acceptance => "generate:all"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:acceptance_spec) do |t|
  t.pattern = FileList['acceptance/verification_spec.rb']
  t.rspec_opts = "--color"
end
task :acceptance => :acceptance_spec

task :default => :acceptance
