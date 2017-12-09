# Use this template to setup Rspec 3.7 for an rails application

# Firstly, let's add some gems to Gemfile ---------------------
gem_group :development, :test do
  gem 'rspec-rails', '~> 3.7'
end

gem_group :test do
  gem 'ffaker'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end

# Now, run bundle --------------------------------------------------
run 'bundle install'

# Install rspec --------------------------------------------------
run 'rails generate rspec:install'

# Remove test if exists
# run 'rm -rf test'

# Setup Shoulda Matchers
insert_into_file 'spec/rails_helper.rb', before: 'RSpec.configure' do <<-RUBY
require 'database_cleaner'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RUBY
end

# Config FactoryGirl and DataCleaner
insert_into_file 'spec/rails_helper.rb', before: /end\Z/ do <<-RUBY

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
RUBY
end

# Create a first test -----------------------------------------------
create_file 'spec/test_spec.rb' do
<<-RUBY
require "rails_helper"

RSpec.describe 'This is an example', :type => :constant do
  pending 'delete this and start writing your first test, have fun!'
end
RUBY
end

# Run test
run 'bundle exec rake db:create RAILS_ENV=test'
run 'bundle exec rake db:migrate RAILS_ENV=test'
run 'rspec'
