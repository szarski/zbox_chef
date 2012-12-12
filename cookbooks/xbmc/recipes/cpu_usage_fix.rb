if node[:autologin] and node[:autologin][:username]
  user = node[:autologin][:username]

  template "/home/#{user}/.xbmc/userdata/advancedsettings.xml" do
    source "advancedsettings.xml.erb"
    mode 0644
    owner user
    group user
    variables(
      :gui => {
        :algorithmdirtyregions => 1,
        :nofliptimeout => 0
      }
    )
  end
end
