default['gate']['url']                    = "gate.gojek.co.id"
default['gate']['nss']['api_key']         = ""

default['gate']['nss']['binary_source']   = "libnss_http.so.2.0_1404" if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
default['gate']['nss']['binary_source']   = "libnss_http.so.2.0_1604" if node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
