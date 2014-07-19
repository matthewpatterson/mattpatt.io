get "/home" do
  erb :homepage
end

get "/" do
  call! env.merge("PATH_INFO" => "/home")
end

not_found do
  @title = "File Not Found - "
  erb :error_404
end
