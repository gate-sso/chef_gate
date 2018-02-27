property :name, String, name_property: true

default_action :setup

action :setup do

  file '/etc/sudoers.d/gate_sudoers' do
    content "%#{node['gate']['sudo_group']} ALL=(ALL) NOPASSWD:ALL"
    mode '0644'
    owner 'root'
    group 'root'
  end

end
