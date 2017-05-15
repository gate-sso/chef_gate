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

cookbook_file "/etc/nsswitch.conf.orig" do
  source "nsswitch.conf.orig"
  owner "root"
  group "root"
  mode  "0644"
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

chef_gate_add_groups_to_host 'add groups' do
  groups node['gate']['host']['groups']
end

cookbook_file "/bin/gate-nss-cache" do
  source "gate-nss-cache"
  owner "root"
  group "root"
  mode  "0755"
end

cron 'adding cron for gate nss cache ' do
  minute '00'
  command '/bin/gate-nss-cache'
end
