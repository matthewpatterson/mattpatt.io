def model(name)
  root = File.dirname(__FILE__)
  json = File.read(File.join(root, "models", name))
  JSON.parse(json, symbolize_names: true)
end

get "/home" do
  erb :homepage
end

get "/about" do
  @title = "About Me - "
  erb :about
end

get "/work" do
  @title = "My Work - "
  @jobs = model("jobs.json")[:jobs]
  erb :work
end

get "/projects" do
  @title = "My Projects - "
  @projects = model("projects.json")
  erb :projects
end

get "/contact" do
  @title = "Contact Me - "
  erb :contact
end

get "/this" do
  @title = "About This Site - "
  erb :site
end

get "/" do
  call! env.merge("PATH_INFO" => "/home")
end

not_found do
  @title = "File Not Found - "
  erb :error_404
end
