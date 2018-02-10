require "json"
require "socket"

require "sinatra"

get "/home" do
  erb :new
end

get "/status" do
  headers["Content-Type"] = "application/json"
  {
    host: Socket.gethostname,
    pid: Process.pid,
    status: "OK",
    timestamp: Time.now,
  }.to_json
end

get "/" do
  call! env.merge("PATH_INFO" => "/home")
end

not_found do
  @title = "File Not Found - "
  erb :error_404
end
