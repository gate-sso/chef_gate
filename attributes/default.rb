default['gate']['url']                                    = "gate.test.com"
default['gate']['nss']['api_key']                         = "HmiMZT4mcmuqtzZw"

override['authorization']['sudo']['include_sudoers_d']    = true
override['authorization']['sudo']['passwordless']         = true
override['authorization']['sudo']['groups']               = ["devops", "sysadmin"]
