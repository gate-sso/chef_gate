require 'net/http'
require 'socket'
require 'json'

uri = URI("https://#{node['gate']['url']}/nss/host")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?
params = { :name => "#{node['hostname']}", :token => "#{node['gate']['nss']['api_key']}" }
uri.query = URI.encode_www_form(params)
res = http.request(Net::HTTP::Get.new(uri.request_uri))
#res = Net::HTTP.get_response(uri)

response_hash = JSON.parse(res.body)

if !response_hash.empty?
  node.override['authorization']['sudo']['groups'] = (response_hash['groups'] + node['authorization']['sudo']['groups']).uniq
end

include_recipe 'sudo'
