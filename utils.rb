def get_app_name
  app_name = File.read(
    "config/application.rb"
  ).match(
    /module\s([^\s]*)\s*class\sApplication/
  )[1]

  app_name.downcase! if app_name

  app_name
end

@app_name = get_app_name
