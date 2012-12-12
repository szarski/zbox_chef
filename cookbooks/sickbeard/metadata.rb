maintainer       "Alex Howells"
maintainer_email "alex@howells.me"
license          "Apache 2.0"
description      "Installs and configures Sickbeard onto a node"
version          "1.0.0"
 
%w{ ubuntu }.each do |os|
  supports os
end
