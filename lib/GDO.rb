 # # # ## # # # 
# # # BOOT # # #
 # # # ## # # #
require "GDO/version"
require "byebug"

##################
### Autoloader ###
##################
module GDO
  module Autoloader
    # Simply include missing constants as is in the file system. e.g.: GDO::Net::GDT_URL  => require "GDO/Net/GDT_URL"
    def const_missing(const_name)
      path = name.gsub('::', '/') + "/#{const_name}"
      require path
      Object.const_get("#{name}::#{const_name}")
    end
  end
  extend Autoloader # apply to module GDO
end

# Apply this simple autoloader to all gdo modules
module GDO
  module Core; extend Autoloader; end
  module Date; extend Autoloader; end
  module DB; extend Autoloader; end
  module File; extend Autoloader; end
  module Form; extend Autoloader; end
  module Install; extend Autoloader; end
  module Lang; extend Autoloader; end
  module Mail; extend Autoloader; end
  module Net; extend Autoloader; end
  module Table; extend Autoloader; end
  module UI; extend Autoloader; end
  module User; extend Autoloader; end
end

####################
### Load plugins ###
####################
# Now load all plugins
#Bundler.setup
#Bundler.load
require "mysql2"

#########################
### Load Core modules ###
#########################
require "GDO/Core/Module"
require "GDO/User/Module"
