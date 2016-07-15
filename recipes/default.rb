#
# Cookbook Name:: chef-gate
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file '/lib/xx86_64*/libnss_http.so.2.0' do
  source 'libnss_http.so.2.0'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory "/etc/gate" do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

template '/etc/gate/nss.yml' do
  source 'nss.yml.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/usr/bin/gate_ssh.sh' do
  source 'gate_ssh.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

bash "append_to_config" do
   user "root"
   code <<-EOF
      echo "AuthorizedKeysCommand /usr/bin/gate_ssh.sh" >> /etc/ssh/sshd_config
      echo "AuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config
   EOF
   not_if "grep -q AuthorizedKeysCommand /etc/ssh/sshd_config"
 end
