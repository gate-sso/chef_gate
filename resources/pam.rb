property :name, String, name_property: true
property :gate_url, String, required: true
property :api_key, String, required: true

default_action :setup

action :setup do

  file '/lib/x86_64-linux-gnu/security/pam_gate.so' do
    action :delete
  end

  cookbook_file '/bin/pam_gate.sh' do
    source "pam_gate.sh"
    owner 'root'
    group 'root'
    mode '0755'
    cookbook 'chef_gate'
    action :create
  end

  bash "append_to_config" do
    user "root"
    code <<-EOF
      echo "\naccount\tsufficient\tpam_exec.so\t/bin/pam_gate.sh" >> /etc/pam.d/common-auth
    EOF
    not_if "grep -q pam_exec.so /etc/pam.d/common-auth"
    notifies :restart, 'service[ssh]', :delayed
  end

  bash "append_to_config" do
    user "root"
    code <<-EOF
      sed -i '/pam_gate.so/d' /etc/pam.d/common-auth
    EOF
    only_if "grep pam_gate.so /etc/pam.d/common-auth"
    notifies :restart, 'service[ssh]', :delayed
  end

  bash "append_to_pam_sshd" do
    user "root"
    code <<-EOF
      echo "#create home directory" >> /etc/pam.d/sshd
      echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=0022" >> /etc/pam.d/sshd
    EOF
    not_if "grep -q pam_mkhomedir.so /etc/pam.d/sshd"
    notifies :restart, 'service[ssh]', :delayed
  end

  service 'ssh' do
    action :nothing
    supports :status => true, :start => true, :stop => true, :restart => true
  end

end
