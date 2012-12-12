# (JS) According to the instructions from mopidy.com
# wget -q -O - http://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
# sudo wget -q -O /etc/apt/sources.list.d/mopidy.list http://apt.mopidy.com/mopidy.list
# sudo apt-get update
# sudo apt-get install mopidy

bash "install repository key" do
  code "wget -q -O - http://apt.mopidy.com/mopidy.gpg | apt-key add -"
  action :run
  not_if "dpkg -l mopidy > /dev/null && echo 1"
end

bash "add repository sources" do
  code "wget -q -O /etc/apt/sources.list.d/mopidy.list http://apt.mopidy.com/mopidy.list && apt-get update"
  action :run
  not_if "dpkg -l mopidy > /dev/null && echo 1"
end

package "mopidy"

system_username = node[:mopidy][:system_user]

bash "create mopidy config directory" do
  code "mkdir -p /home/#{system_username}/.config/mopidy"
  action :run
end

template "/home/#{system_username}/.config/mopidy/settings.py" do
  source "settings.py.erb"
  mode 0644
  owner system_username
  group system_username
  variables(
    :mopidy_host => node[:mopidy][:hostname],
    :spotify_username => node[:mopidy][:spotify_username],
    :spotify_password => node[:mopidy][:spotify_password],

    :lastfm_username => node[:mopidy][:lastfm_username],
    :lastfm_password => node[:mopidy][:lastfm_password],

    :mixer => node[:mopidy][:mixer],
    :output => node[:mopidy][:output]
  )
end

bash "create mopidy logfile" do
  code "touch /var/log/mopidy.log && chmod 644 /var/log/mopidy.log && chown #{system_username}:root /var/log/mopidy.log"
  action :run
end

template "/etc/init/mopidy.conf" do
  source "mopidy.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :mopidy_username => system_username,
    :mopidy_log_path => "/var/log/mopidy.log"
  )
end
