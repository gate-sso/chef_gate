default['gate']['url']                                    = "p-gate-01.c.infrastructure-904.internal"
default['gate']['public_url']                             = "gate.gojek.co.id"
default['gate']['nss']['api_key']                         = "umTChO5vPhx0sPtAVuQM"
default['sudo_groups']                                    = ["devops", "sysadmin"]

override['authorization']['sudo']['include_sudoers_d']    = true
override['authorization']['sudo']['passwordless']         = true
