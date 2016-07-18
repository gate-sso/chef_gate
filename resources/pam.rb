property :name, String, name_property: true
property :gate_url, String, required: true

default_action :setup

action :setup do

  if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
    binary_source = "pam_gate.so_1404"
  elsif node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
    binary_source = "pam_gate.so_1604"
  end

  cookbook_file '/lib/x86_64-linux-gnu/security/pam_gate.so' do
    source binary_source
    owner 'root'
    group 'root'
    mode '0755'
    cookbook 'chef_gate'
    action :create
  end

  bash "append_to_config" do
    user "root"
    code <<-EOF
      echo "\nauth\tsufficient\tpam_gate.so\turl=#{gate_url}/profile/authenticate_pam" >> /etc/pam.d/common-auth
      echo "account\tsufficient\tpam_gate.so" >> /etc/pam.d/common-auth
    EOF
    not_if "grep -q pam_gate.so /etc/pam.d/common-auth"
    notifies :restart, 'service[ssh]', :delayed
  end

  service 'ssh' do
    action :nothing
    supports :status => true, :start => true, :stop => true, :restart => true
  end

end
