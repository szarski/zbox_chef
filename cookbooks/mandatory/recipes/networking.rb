
template "/etc/network/interfaces" do
  source "interfaces.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :interface => "eth0",
    :address => "192.168.1.2",
    :netmask => "255.255.255.0",
    :gateway => "192.168.1.1"
  )
end
