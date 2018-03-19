include_recipe 'apt'

group 'devops' do
  action :create
end

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

ruby_block 'change chef client binary' do
  block do
    file = Chef::Util::FileEdit.new("/usr/bin/chef-client")
    file.insert_line_after_match(/.*embedded.*$/, "require 'fileutils'\nFileUtils.cp '/etc/nsswitch.conf.orig', '/etc/nsswitch.conf'")
    file.write_file
  end
  action :run
  not_if 'cat /usr/bin/chef-client | grep nsswitch.conf.orig'
end

cookbook_file "/bin/gate-nss-cache" do
  source "gate-nss-cache"
  owner "root"
  group "root"
  mode  "0755"
end

template "/etc/gate/nss_cron.sh" do
  source "nss_cron.sh.erb"
  owner "root"
  group "root"
  mode  "0755"
  cookbook 'chef_gate'
  variables(
    cron_duration: node['gate']['nss']['cron_duration']
  )
end

cron 'adding cron for gate nss cache ' do
  minute "*/#{node['gate']['nss']['cron_duration']}"
  command %W{
    /bin/bash
    /etc/gate/nss_cron.sh
  }.join(' ')
end
