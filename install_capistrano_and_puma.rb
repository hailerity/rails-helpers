# Use this template to setup Capistrano & Puma for a rails application

# Firstly, let's add some gems to Gemfile ---------------------
gem_group :development, :test do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
end

gem 'puma'

run 'bundle install'

run 'bundle exec cap install'

# Update Capfile
remove_file 'Capfile'
copy_file Pathname.new(File.dirname(__FILE__)).join('file_templates/Capfile'), 'Capfile'

# Create deploy.rb
remove_file 'config/deploy.rb'
copy_file Pathname.new(File.dirname(__FILE__)).join('file_templates/deploy.rb'), 'config/deploy.rb'

# Create nginx.conf
remove_file 'config/nginx.conf'
copy_file Pathname.new(File.dirname(__FILE__)).join('file_templates/nginx.conf'), 'config/nginx.conf'

# Auto get app name
rails_app_name = File.read("config/application.rb").match(/module\s([^\s]*)\s*class\sApplication/)[1]
rails_app_name.downcase! if app_name

repo_url = `git config --get remote.origin.url`
repo_url.strip! unless repo_url.blank?

server_addr = ask('Your server address (127.0.0.1 if skip): ')
user = ask('Your user (rails if skip): ')
app_name = ask("Your app name (#{rails_app_name} if skip): ")

server_addr = '127.0.0.1' if server_addr.blank?
user = 'rails' if user.blank?
app_name = rails_app_name if app_name.blank?

puts "Couldn't identify your repo url, please update your repo url in config/deploy.rb" if repo_url.blank?

# Update deploy.rb
gsub_file 'config/deploy.rb', "<server_addr>", server_addr
gsub_file 'config/deploy.rb', "<user>", user
gsub_file 'config/deploy.rb', "<app_name>", app_name
gsub_file 'config/deploy.rb', "<repo_url>", repo_url if not repo_url.blank?

# Update nginx.conf
gsub_file 'config/nginx.conf', "<user>", user
gsub_file 'config/nginx.conf', "<app_name>", app_name

