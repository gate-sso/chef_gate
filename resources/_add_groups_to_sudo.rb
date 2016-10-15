property :name, String, name_property: true

default_action :setup

action :setup do

  require 'net/http'
  require 'socket'
  require 'json'

  uri = URI("https://#{node['gate']['public_url']}/nss/host")
  params = { :name => "#{node['hostname']}", :token => "#{node['gate']['nss']['api_key']}" }
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)

  response_hash = JSON.parse(res.body)

  if !response_hash.empty?
    node.override['authorization']['sudo']['groups'] = (response_hash['groups'] << "devops").uniq
  else
    node.override['authorization']['sudo']['groups'] = node['gate']['host']['groups']
  end
  include_recipe 'sudo'

end
