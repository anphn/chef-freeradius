#
# Cookbook:: install_freeradius
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#include_recipe 'install_freeradius::fradius'

# Install dependencies
%w(libtalloc-devel openssl-devel libpcap-devel postgresql-devel).each do |pkg|
  package pkg do
    action :install
  end
end
## Install freeradius from source
version = node[:freeradius][:version]
install_path = "#{node[:freeradius][:prefix_dir]}/sbin/radiusd"

remote_file "/tmp/freeradius_#{version}.tar.gz" do
  source "#{node['freeradius']['url']}/release_#{version}.tar.gz"
  mode "0644"
  not_if { File.exists?(install_path)}
end

bash "build-and-install-freeradius" do
  cwd "/tmp/"
  code <<-EOH
  tar zxvf freeradius_#{version}.tar.gz
  cd /tmp/freeradius-server-release_#{version}
  sudo ./configure --with-modules=rlm_sql_postgresql
  sudo make
  sudo make install
  EOH
end
## Copy systemd scripts
template "/etc/systemd/system/radiusd.service" do
  source 'radiusd.init.erb'
end

## Reload deamon
execute 'daemon-reload' do
  command "systemctl daemon-reload"
  action :nothing
end

## install sql
if node['freeradius']['enable_sql'] == true

template "#{node['freeradius']['dir']}/mods-available/sql" do
  source "sql.erb"
  mode 0600
  notifies :restart, "service[#{node['freeradius']['service']}]", :immediately
end 

## config client
template "#{node['freeradius']['dir']}/clients.conf" do
  source "clients.conf.erb"
  mode 0600
  notifies :restart, "service[#{node['freeradius']['service']}]", :immediately
end
## enalbe module sql
link node['freeradius']['dir'] + '/mods-enabled/sql' do
  to node['freeradius']['dir'] + '/mods-available/sql'
  end
end

## start service
service node['freeradius']['service'] do
  supports :restart => true, :status => false, :reload => false
  action [:enable, :start]
end
