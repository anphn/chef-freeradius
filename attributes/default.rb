# OS Specific Attributes
default['freeradius']['dir'] = '/usr/local/etc/raddb'
default['freeradius']['service'] = 'radiusd'
default['freeradius']['version'] = "3_0_4"

# Db vars 
default['freeradius']['enable_sql'] = true
default['freeradius']['db_type'] = "postgresql"
default['freeradius']['db_server'] = "localhost"
default['freeradius']['db_port'] = "5432"
default['freeradius']['db_name'] = "radius"
default['freeradius']['db_login'] = "radius"
default['freeradius']['db_password'] = "radius"

# Client Config
default['freeradius']['local_secret'] = "testing1234"
default['freeradius']['enable_remote_clients'] = true
default['freeradius']['remote_secret'] = "remote1234"

# Client File Config
default['freeradius']['clients'] = {
  'localhost' => {
    'ipaddr' => '127.0.0.1',
    'secret' => 'default_secret',
    'nas_type' => 'other'
  }
}
default['freeradius']['url'] = "https://github.com/FreeRADIUS/freeradius-server/archive"
default['freeradius']['version'] = "3_0_4"

