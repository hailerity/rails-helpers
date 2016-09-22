# Use this template to setup Rspec for an rails application

# Firstly, let's add some gems to Gemfile ---------------------
gem_group :development, :test do
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'master'
  end
  gem 'capybara'
  gem 'factory_girl_rails'
end

# Now, run bundle --------------------------------------------------
run 'bundle install'
# Install rspec --------------------------------------------------
run 'rails generate rspec:install'
# Remove test if exists
# run 'rm -rf test'

# Create a first test -----------------------------------------------
create_file 'spec/test_spec.rb' do
<<-RUBY
require "rails_helper"

RSpec.describe 'Make sure the truth', :type => :constant do
  it "is not wrong" do
    expect(true).to be
  end
end
RUBY
end

# Run test
run 'rspec'
