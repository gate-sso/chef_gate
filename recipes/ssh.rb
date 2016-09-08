include_recipe 'apt'

group 'devops' do
  action :create
end

include_recipe 'sudo'

chef_gate_nss 'nss setup' do
  gate_url node['gate']['url']
  api_key node['gate']['nss']['api_key']
end

chef_gate_ssh 'ssh setup' do
  gate_url node['gate']['url']
end

chef_gate_pam 'ssh setup' do
  gate_url node['gate']['url']
  api_key node['gate']['nss']['api_key']
end

cookbook_file "/etc/nsswitch.conf.orig" do
  source "nsswitch.conf.orig"
  owner "root"
  group "root"
  mode  "0644"
end

if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
  Chef::Util::FileEdit.new('/usr/bin/chef-client').insert_line_after_match(/embedded/, "require 'fileutils'\nFileUtils.cp '/etc/nsswitch.conf.orig', '/etc/nsswitch.conf'")
end
