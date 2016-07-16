source 'https://supermarket.chef.io'

group :integration do
  cookbook 'test-helper', git: 'https://github.com/lipro-cookbooks/test-helper.git'
  cookbook 'gate_test', path: "#{File.dirname(__FILE__)}/test/integration/cookbooks/gate_test"
end

metadata
