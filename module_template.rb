# >---------------------------------------------------------------------------<
#
#   Rails application template for generating a rails engine.
#   I just hate to generate the same rails engine many times.
#
#   Created by Hai Le
#   Use this file when you run something like
#   rails plugin new depot --skip-unit-test --mountable
#   Change it to
#   rails plugin new depot --skip-unit-test --skip-active-record --mountable -m path/to/this_file
#   Or after create engine do
#   rake app:rails:template LOCATION=path/to/this_file
# >---------------------------------------------------------------------------<

# Something helpful
# @app_name: app name
# @app_path: app path
# or app_path = ARGV.first

# >----------------------------[ Add Namespace ]------------------------------<

# What to do
# 1. Move all depot inside athena
# 2. In gemspec: change require, name, version
# 3. Change lib file
# 4. Change engine file, version file
# 5. Change path in bin/rails

# Try a lot to get the engine name, but failed, so let try this
@engine_name = File.basename(Dir.glob(Rails.root.join('../../*.gemspec')).first, '.*')
@engine_path = Rails.root.join('../../')

def add_namespace namespace
  # Move assets to module
  ['images', 'javascripts', 'stylesheets'].each do |asset|
    inside(@engine_path.join("app/assets/#{asset}")) do
      run "mkdir #{namespace}"
      run "mv #{@engine_name} #{namespace}/#{@engine_name}"
    end
  end

  # Move things to module
  ['helpers', 'controllers', 'models'].each do |name|
    inside(@engine_path.join("app/#{name}")) do
      run "mkdir #{namespace}"
      run "mv #{@engine_name} #{namespace}/#{@engine_name}"
    end
  end
  inside(@engine_path.join("app/views/layouts")) do
    run "mkdir #{namespace}"
    run "mv #{@engine_name} #{namespace}/#{@engine_name}"
  end

  # Move in lib
  inside(@engine_path.join("lib")) do
    run "mkdir #{namespace}"
    run "mv #{@engine_name} #{namespace}/#{@engine_name}"
  end

  # Rename gemspec
  inside(@engine_path) do
    run "mv #{@engine_name}.gemspec #{namespace}_#{@engine_name}.gemspec"
  end
end
# Move views to module

# >----------------------------[ # Install Rspec ]----------------------------<

# >----------------------------[ # Install Mongoid ]--------------------------<

# Add namespace
add_namespace 'athena'