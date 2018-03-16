property :name, String, name_property: true
property :gate_url, String, required: true

default_action :setup

action :setup do

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
