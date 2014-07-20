get "/home" do
  erb :homepage
end

get "/about" do
  @title = "About Me - "
  erb :about
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
