node[:fstab][:devices].values.each do |disk|

  execute "create mountpoint #{disk[:mount_point]}" do
    command "mkdir #{disk[:mount_point]}"
    not_if "ls #{disk[:mount_point]}"
  end

  mount disk[:device] do
    for k, v in disk do
      self.send k, v
    end
  end

end
