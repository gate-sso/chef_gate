property :name, String, name_property: true
property :groups, Array, name_property: true, required: true
property :gate_url, String, required: true

default_action :setup

action :setup do
  require 'net/http'
  require 'socket'
  require 'json'

  uri = URI("https://#{node['gate']['public_url']}/nss/host")
  groups.each do |group|
    res = Net::HTTP.post_form(uri,"name" => "#{node['hostname']}", "token" => "#{node['gate']['nss']['api_key']}", "group_name" => "#{group}")

    if res.code != "200"
      raise node['gate']['http']['bad_response_message']
    end

    response_body = JSON.parse(res.body)

    if response_body.nil? || response_body["access_key"].nil?
      raise node['gate']['http']['empty_token_exception_message']
    end

    template '/etc/gate/nss.yml' do
      source 'nss.yml.erb'
      owner 'root'
      group 'root'
      mode '0644'
      cookbook 'chef_gate'
      variables(
        gate_url: new_resource.gate_url,
        api_key: response_body["access_key"]
      )
    end
  end

  chef_gate__add_groups_to_sudo 'add_sudo'
end
