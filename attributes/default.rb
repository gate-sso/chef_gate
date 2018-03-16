default['gate']['url']                                    = "mygate.test.com"
default['gate']['public_url']                             = "mygate.test.com"
default['gate']['nss']['api_key']                         = "1234567899"
default['gate']['nss']['cron_duration']                   = "5"


override['authorization']['sudo']['include_sudoers_d']    = true
override['authorization']['sudo']['passwordless']         = true

default['gate']['host']['groups']                         = ['sysadmin']
default['gate']['sudo_group']                             = "sysadmins"
default['gate']['http']['bad_response_message']           = "Bad response from Gate"
default['gate']['http']['empty_token_exception_message']  = "Empty Token from Gate"

