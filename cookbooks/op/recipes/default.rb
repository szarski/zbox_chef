## --- Install packages we need ---
#package 'ntp'
#package 'sysstat'
#package 'apache2'
#
## --- Add the data partition ---
#directory '/mnt/data_joliss'
#
#mount '/mnt/data_joliss' do
#  action [:mount, :enable]  # mount and add to fstab
#  device 'data_joliss'
#  device_type :label
#  options 'noatime,errors=remount-ro'
#end
#
## --- Set host name ---
## Note how this is plain Ruby code, so we can define variables to
## DRY up our code:
#hostname = 'opinionatedprogrammer.com'
#
#file '/etc/hostname' do
#  content "#{hostname}\n"
#end
#
#service 'hostname' do
#  action :restart
#end
#
#file '/etc/hosts' do
#  content "127.0.0.1 localhost #{hostname}\n"
#end
#
## --- Deploy a configuration file ---
## For longer files, when using 'content "..."' becomes too
## cumbersome, we can resort to deploying separate files:
#cookbook_file '/etc/apache2/apache2.conf'
## This will copy cookbooks/op/files/default/apache2.conf (which
## you'll have to create yourself) into place. Whenever you edit
## that file, simply run "./deploy.sh" to copy it to the server.
#
#service 'apache2' do
#  action :restart
#end


package 'ntop'

################################ SPINDOWN IDLE DRIVE ################################

package 'sdparm'

node[:spindown_idle_drive] = {
  spindown_time: 300, #seconds
  stats_file: '/tmp/spindown_idle_drive_temp_stats',
  logfile: '/var/log/spindown_idle_drive.log',
  drives: %w{sdb3}
}

template "/usr/bin/spindown_idle_drive" do
  source "spindown_idle_drive.erb"
  mode 0755
  owner "root"
  group "root"
  variables(
    :spindown_time => node[:spindown_idle_drive][:spindown_time],
    :stats_file => node[:spindown_idle_drive][:stats_file],
    :logfile => node[:spindown_idle_drive][:logfile]
  )
end

node[:spindown_idle_drive][:drives].each do |drive_name|
  cron "spindown_idle_drive" do
    minute "*"
    command "/usr/bin/spindown_idle_drive #{drive_name} > #{node[:spindown_idle_drive][:logfile]} 2>&1"
    user "root"
  end
end

################################ AUTOLOGIN ################################

settings = {
  "AutoLoginEnable" => "true",
  "AutoLoginDelay" => "10",
  "AutoLoginUser" => "guest"
}

replaceables = settings.collect{|attribute_name, value| ["#{attribute_name}.*", "#{attribute_name}=#{value}"]}
filename="/etc/kde4/kdm/kdmrc"
script = "sed -i'.backup_#{Time.now.to_i}' #{replaceables.collect{|a,b| "-e 's/#{a}/#{b}/'"}.join(' ')} #{filename}"

bash "update kde autologin configuration" do
  user "root"
  action :run
  code script
end

################################ ROMPR ################################

#(JS) according to: http://sourceforge.net/p/rompr/wiki/Installation/

package 'apache2'
package 'php5-curl'
package 'imagemagick'
package 'libapache2-mod-php5'

node[:rompr] = {
  :download_source => "http://downloads.sourceforge.net/project/rompr/rompr-0.08.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Frompr%2Ffiles%2F&ts=1338845870&use_mirror=switch",
  :deploy_dir => "/var/www/rompr",
  :config_file => "/etc/apache2/conf.d/rompr.conf",
  :mopidy_host => "192.168.1.2"
}

remote_file "/tmp/rompr.zip" do
 source node[:rompr][:download_source]
 mode "0777"
end

execute "unzip archive" do
 command "[ -d /tmp/rompr ] && rm -rf /tmp/rompr; cd /tmp && unzip /tmp/rompr.zip && rm -rf /tmp/rompr.zip"
 action :run
end

execute "deploy" do
 command "[ -d #{node[:rompr][:deploy_dir]} ] && rm -rf #{node[:rompr][:deploy_dir]};mv /tmp/rompr #{node[:rompr][:deploy_dir]} && chown -R www-data #{node[:rompr][:deploy_dir]} && chmod -R 760 #{node[:rompr][:deploy_dir]} && rm -rf /tmp/rompr"
 action :run
end

execute "set the configuration file" do
  temp_config_file = "#{node[:rompr][:deploy_dir]}/apache_conf.d/rompr.conf"
  script = "sed -e 's/#{"/PATH-TO-ROMPR".gsub('/','\\/')}/#{node[:rompr][:deploy_dir].gsub('/','\\/')}/' #{temp_config_file} > #{node[:rompr][:config_file]}"
  puts script
  command script
  action :run
end

template "#{node[:rompr][:deploy_dir]}/prefs/prefs" do
  source "prefs"
  mode 0440
  owner "www-data"
  group "www-data"
  variables(
    :mopidy_host => node[:rompr][:mopidy_host]
  )
end

execute "enable apache modules" do
  command %w{expires headers deflate php5}.collect{|m| "a2enmod #{m}"}.join(';')
  action :run
end

execute "restart apache" do
  command "service apache2 restart"
  action :run
end
