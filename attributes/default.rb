default['gate']['url']                                    = "mygate.test.com"
default['gate']['public_url']                             = "mygate.test.com"
default['gate']['nss']['api_key']                         = "1234567899"
default['sudo_groups']                                    = ["devops", "sysadmin"]

override['authorization']['sudo']['include_sudoers_d']    = true
override['authorization']['sudo']['passwordless']         = true
