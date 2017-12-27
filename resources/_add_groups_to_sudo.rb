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
    node.override['authorization']['sudo']['groups'] = (response_hash['groups'] + node['gate']['host']['groups']).uniq
  else
    node.override['authorization']['sudo']['groups'] = node['gate']['host']['groups']
  end

  node['authorization']['sudo']['groups'].each do |item|
    file = Chef::Util::FileEdit.new('/etc/sudoers')
    file.insert_line_if_no_match(/%#{item} ALL=\(ALL\) NOPASSWD:ALL/, "%#{item} ALL=(ALL) NOPASSWD:ALL")
    file.write_file
  end
end
