# Add dependencies
inside('../../') do

  gemspec_file = Dir.glob('*.gemspec').first
  # Update gemspec --------------------------------------------------
  gsub_file gemspec_file, "s.test_files = Dir[\"test/**/*\"]\n", ''
  insert_into_file gemspec_file, before: /end(?!.*end)/m do
  <<-RUBY

  # Test framework dependencies
  s.test_files = Dir["spec/**/*"]
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  RUBY
  end

  # Update Rakefile -------------------------------------------------
  remove_file 'Rakefile'
  create_file 'Rakefile' do
<<-RUBY
#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }

require 'rspec/core'
require 'rspec/core/rake_task'

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')

task :default => :spec
RUBY
  end

  # Run bundle --------------------------------------------------
  run 'bundle install'
  # Install rspec --------------------------------------------------
  run 'rails generate rspec:install'
  # Update rails_helper
  gsub_file 'spec/rails_helper.rb', '../../config/environment', '../dummy/config/environment.rb'
  # Remove test if exists
  run 'rm -rf test'

  # Update engine.rb --------------------------------------------------
  insert_into_file Dir.glob('lib/**/engine.rb').first, after: /isolate_namespace.*$/ do
    <<-RUBY


    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
    RUBY
  end

  # Create a first test -----------------------------------------------
  gem_class = File.basename(gemspec_file, ".*").capitalize.constantize
  create_file 'spec/test_spec.rb' do
<<-RUBY
require "rails_helper"

RSpec.describe #{gem_class}, :type => :constant do
  it "should be declared" do
    expect(#{gem_class}).to be
  end
end
RUBY
  end

  # Run test
  run 'rspec'
end