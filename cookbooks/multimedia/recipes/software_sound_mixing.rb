#taken from http://ubuntuforums.org/printthread.php?t=32063&pp=40

package 'libesd0'

template "/etc/asound.conf" do
  source "asound.conf.erb"
  mode 0755
  owner "root"
  group "root"
  backup 10
end


template "/etc/esound/esd.conf" do
  source "esd.conf.erb"
  mode 0755
  owner "root"
  group "root"
  backup 10
end

execute "change audio sink to alsa" do
  command 'gconftool-2 --type string --set /system/gstreamer/0.10/default/audiosink "alsasink" && gconftool-2 --type string --set /system/gstreamer/0.10/default/musicaudiosink "alsasink"'
  action :run
end
