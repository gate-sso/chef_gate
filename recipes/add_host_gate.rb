require 'net/http'
require 'socket'
require 'json'

uri = URI("https://#{node['gate']['public_url']}/nss/host")
res = Net::HTTP.post_form(uri,"name" => "#{node['hostname']}", "token" => "#{node['gate']['nss']['api_key']}")
