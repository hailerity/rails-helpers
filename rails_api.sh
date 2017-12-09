# Create rails api app
echo -e "\E[0;32m # Creating new app ..."
app_name=$1
rails new $app_name --api -T -d postgresql

echo -e "\E[0;32m \n# Move to app directory"
cd $app_name

git add .
git commit -m 'initialize project'

# User Rspec
echo -e "\E[0;32m \n# Installing Rspec ..."
bundle exec rake app:template LOCATION=/home/hailerity/Workspaces/Hailerity/rails-helpers/install_rspec_3.7_for_app.rb
git add .
git commit -m 'install rspec'

# jsonapi-resources
echo -e "\E[0;32m \n# Installing jsonapi-resources ..."
bundle exec rake app:template LOCATION=/home/hailerity/Workspaces/Hailerity/rails-helpers/install_jsonapi_resources.rb
git add .
git commit -m 'install jsonapi-resources'

echo -e "\E[0;32m \n# Creating Dockerfile ..."
bundle exec rake app:template LOCATION=/home/hailerity/Workspaces/Hailerity/rails-helpers/install_docker.rb
git commit -m 'create Dockerfile'

# Finish
echo -e "\n\n"
echo -e "\E[0;32mFooh, finish!"
echo -e "\E[0;32mWhat have done are:!"
echo -e "\E[0;32m   Create rails app api mode"
echo -e "\E[0;32m   Using postgres"
echo -e "\E[0;32m   Install rspec"
echo -e "\E[0;32m   Install jsonapi-resources"
echo -e ""
echo -e "\E[0;32mNow, start writing your own code."
echo -e "\E[0;32mHappy coding!"
