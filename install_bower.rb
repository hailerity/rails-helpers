# Just want to install bower
# Overview
# 1. Add gem to Gemfile
# 2. run bower initiaize
# 3. Add assets to Bowerfile
# 4. Update .gitignore
# 5. Run bower install
# 6. Update config/application
# 7. Update application.js
# 8. Update application.css

gem "bower-rails", "~> 0.10.0"
run 'rails g bower_rails:initialize'

remove_file "Bowerfile"
create_file 'Bowerfile' do <<-RUBY
# General assets
asset 'bootstrap-material-design', '~0.3.0'
asset 'bootstrap-sass', '~3.3.5'
asset 'jquery-validation', '~1.14.0'
asset 'eonasdan-bootstrap-datetimepicker'
asset 'bootstrap-select'
RUBY
end

insert_into_file '.gitignore', before: '/tmp' do <<-CODE
/vendor/assets/bower_components/*
CODE
end

run 'rake bower:install'

insert_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-RUBY
    # Bower asset paths
    root.join('vendor', 'assets', 'bower_components').to_s.tap do |bower_path|
      config.sass.load_paths << bower_path
      config.assets.paths << bower_path
    end

    # Precompile Bootstrap fonts
    config.assets.precompile << %r(bootstrap-sass/assets/fonts/bootstrap/[\w-]+\.(?:eot|svg|ttf|woff2?)$)

    # Minimum Sass number precision required by bootstrap-sass
    ::Sass::Script::Value::Number.precision = [8, ::Sass::Script::Value::Number.precision].max

RUBY
end

inside('app/assets/stylesheets/') do
  run 'mv application.css application.scss'
  insert_into_file 'application.scss', after: /\*\// do <<-CODE


$icon-font-path: "bootstrap-sass/assets/fonts/bootstrap/";
@import "bootstrap-sass/assets/stylesheets/bootstrap-sprockets";
@import "bootstrap-sass/assets/stylesheets/bootstrap";
@import "eonasdan-bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min";
@import "bootstrap-select/dist/css/bootstrap-select";
CODE
  end
end

inside('app/assets/javascripts/') do
  insert_into_file 'application.js', after: '//= require_tree .' do <<-CODE


//= require moment/min/moment.min
//= require bootstrap-sass/assets/javascripts/bootstrap.min
//= require bootstrap-sass/assets/javascripts/bootstrap/transition
//= require bootstrap-sass/assets/javascripts/bootstrap/collapse
//= require bootstrap-select/dist/js/bootstrap-select
//= require eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min
CODE
  end
end

# git add: "."
# git commit: "-a -m 'Install bower and assets'"