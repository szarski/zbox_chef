#
# Cookbook Name:: sickbeard
# Recipe:: default
#
# Copyright 2012, Alex Howells <alex@howells.me>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

user node['sickbeard']['user'] do
  shell '/bin/bash'
  comment 'Web Application - Sickbeard'
  home node['sickbeard']['install_dir']
  system true
end

app_dirs = [ 
  "#{node['sickbeard']['install_dir']}", 
  "#{node['sickbeard']['config_dir']}", 
  "#{node['sickbeard']['log_dir']}",
  "#{node['sickbeard']['data_dir']}"
  ]

app_dirs.each do |x|
  directory x do
    mode 0755
    owner node['sickbeard']['user']
    group node['sickbeard']['group']
    recursive true
  end
end

git node['sickbeard']['install_dir'] do
  repository node['sickbeard']['git_url']
  revision node['sickbeard']['git_ref']                                   
  action :sync                                     
  user node['sickbeard']['user']                 
  group node['sickbeard']['group']                      
  notifies :restart, "bluepill_service[sickbeard]", :immediately
end

case node["sickbeard"]["init_style"]
when 'bluepill'

  include_recipe "bluepill"

  template "#{node['bluepill']['conf_dir']}/sickbeard.pill" do
    source "sickbeard.pill.erb"
    mode 0644
    notifies :load, "bluepill_service[sickbeard]", :immediately
    notifies :restart, "bluepill_service[sickbeard]", :immediately
  end

  bluepill_service "sickbeard" do
    action [:enable, :load, :start]
  end

else
  Chef::Log.warn("sickbeard::service >> unable to determine valid init_style, manual intervention will be needed to start Sickbeard as a service.")
end
