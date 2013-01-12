apache_site "default" do
  enable false
end

web_app "sickbeard" do
end

basicauth_users = node["sickbeard"]["basicauth_users"]
first_user = basicauth_users.shift

[first_user].compact.each do |u,p|
  htpasswd "/var/www/sickbeard/apache_passwd" do
    user u
    password p
    action :overwrite
  end
end

basicauth_users.each do |u,p|
  htpasswd "/var/www/sickbeard/apache_passwd" do
    user u
    password p
    action :add
  end
end
