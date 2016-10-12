require 'net/http'
require 'socket'
require 'json'

uri = URI("https://#{node['gate']['public_url']}/nss/host")
params = { :name => "#{node['hostname']}", :token => "#{node['gate']['nss']['api_key']}" }
uri.query = URI.encode_www_form(params)
res = Net::HTTP.get_response(uri)

response_hash = JSON.parse(res.body)

if !response_hash.empty?
  node.override['authorization']['sudo']['groups'] = (response_hash['groups'] + node['sudo_groups']).uniq
else
  node.override['authorization']['sudo']['groups'] = node['sudo_groups']
end

include_recipe 'sudo'
