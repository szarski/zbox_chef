# (JS) According to the instructions from mopidy.com
# wget -q -O - http://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
# sudo wget -q -O /etc/apt/sources.list.d/mopidy.list http://apt.mopidy.com/mopidy.list
# sudo apt-get update
# sudo apt-get install mopidy

bash "install repository key" do
  code "wget -q -O - http://apt.mopidy.com/mopidy.gpg | apt-key add -"
  action :run
end

bash "add repository sources" do
  code "wget -q -O /etc/apt/sources.list.d/mopidy.list http://apt.mopidy.com/mopidy.list && apt-get update"
  action :run
end

package "mopidy"
