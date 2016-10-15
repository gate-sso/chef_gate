property :name, String, name_property: true
property :groups, Array, name_property: true, required: true

default_action :setup

action :setup do

  require 'net/http'
  require 'socket'
  require 'json'

  uri = URI("https://#{node['gate']['public_url']}/nss/host")
  groups.each do |group|
    Net::HTTP.post_form(uri,"name" => "#{node['hostname']}", "token" => "#{node['gate']['nss']['api_key']}", "group_name" => "#{group}")
  end

  chef_gate__add_groups_to_sudo 'add_sudo'

end
