default['gate']['url']                                    = "mygate.test.com"
default['gate']['public_url']                             = "mygate.test.com"
default['gate']['nss']['api_key']                         = "1234567899"

override['authorization']['sudo']['include_sudoers_d']    = true
override['authorization']['sudo']['passwordless']         = true

default['gate']['host']['groups']                         = ['sysadmin']
