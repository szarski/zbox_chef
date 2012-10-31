if node[:autologin][:enabled]
  execute "create autologin user" do
    command "adduser #{node[:autologin][:username]}"
    action :run
    not_if "cat /etc/passwd | grep #{node[:autologin][:username]}"
  end
end

template "/etc/lightdm/lightdm.conf" do
  source "lightdm.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :default_session => node[:autologin][:default_session],
    :autologin_enabled => node[:autologin][:enabled],
    :autologin_user => node[:autologin][:username],
    :autologin_timeout => node[:autologin][:timeout],
  )
end
