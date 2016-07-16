property :name, String, name_property: true
property :gate_url, String, required: true
property :api_key, String, required: true

default_action :setup

action :setup do

  if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
    binary_source = "libnss_http.so.2.0_1404"
  elsif node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
    binary_source = "libnss_http.so.2.0_1604"
  end

  cookbook_file '/lib/x86_64-linux-gnu//libnss_http.so.2.0' do
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

  template '/etc/gate/nss.yml' do
    source 'nss.yml.erb'
    owner 'root'
    group 'root'
    mode '0644'
    cookbook 'chef_gate'
    variables(
      gate_url: new_resource.gate_url,
      api_key: new_resource.api_key
    )
  end

  template '/usr/bin/gate_ssh.sh' do
    source 'gate_ssh.sh.erb'
    owner 'root'
    group 'root'
    mode '0755'
    cookbook 'chef_gate'
    variables(
      gate_url: new_resource.gate_url
    )
  end

  bash "append_to_config" do
    user "root"
    code <<-EOF
      echo "\nAuthorizedKeysCommand /usr/bin/gate_ssh.sh" >> /etc/ssh/sshd_config
      echo "\nAuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config
    EOF
    not_if "grep -q gate_ssh.sh /etc/ssh/sshd_config"
    notifies :restart, 'service[ssh]', :delayed
  end

  service 'ssh' do
    action :nothing
    supports :status => true, :start => true, :stop => true, :restart => true
  end

end
