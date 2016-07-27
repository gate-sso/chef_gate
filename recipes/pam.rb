chef_gate_nss 'nss setup' do
  gate_url node['gate']['url']
  api_key node['gate']['nss']['api_key']
end

chef_gate_pam 'ssh setup' do
  gate_url node['gate']['url']
  api_key node['gate']['nss']['api_key']
end
