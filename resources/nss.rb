property :name, String, name_property: true
property :gate_url, String, required: true
property :api_key, String, required: true

default_action :setup

action :setup do

  package ['libcurl4-openssl-dev', 'libjansson-dev', 'libyaml-dev']

  if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
    binary_source = "libnss_cache.so.2.0_1404"
  elsif node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
    binary_source = "libnss_cache.so.2.0_1604"
  end

  cookbook_file '/usr/lib/libnss_cache.so.2.0' do
    source binary_source
    owner 'root'
    group 'root'
    mode '0755'
    cookbook 'chef_gate'
    action :create
  end

  directory "/etc/gate" do
    owner 'root'
    group 'root'
    mode 0755
    action :create
  end

  template '/etc/nsswitch.conf' do
    source 'nsswitch.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    cookbook 'chef_gate'
  end

  link '/usr/lib/libnss_cache.so.2' do
    to '/usr/lib/libnss_cache.so.2.0'
    owner 'root'
    group 'root'
  end

  chef_gate_add_groups_to_host 'add groups' do
    groups node['gate']['host']['groups']
    gate_url new_resource.gate_url
  end
end
