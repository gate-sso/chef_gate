require 'net/http'
require 'socket'
require 'json'

uri = URI("https://#{node['gate']['url']}/nss/host")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?
request = Net::HTTP::Post.new(uri.request_uri)
request.set_form_data({"name" => "#{node['hostname']}", "token" => "#{node['gate']['nss']['api_key']}"})

res = http.request(request)
