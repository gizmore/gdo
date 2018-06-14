 # # # ## # # # 
# # # BOOT # # #
 # # # ## # # #
require "GDO/version"

##################
### Autoloader ###
##################
module GDO
  module Autoloader
    # Simply include missing constants as is in the file system. e.g.: GDO::Net::GDT_URL  => require "GDO/Net/GDT_URL"
    def const_missing(const_name)
      begin
        path = name.gsub('::', '/') + "/#{const_name}"
        require path
        Object.const_get("#{name}::#{const_name}")
      rescue LoadError => e
        nil
      end
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
  module Javascript; extend Autoloader; end
  module Lang; extend Autoloader; end
  module Mail; extend Autoloader; end
  module Method; extend Autoloader; end
  module Net; extend Autoloader; end
  module Table; extend Autoloader; end
  module UI; extend Autoloader; end
  module User; extend Autoloader; end
end


# Global helpers
::GDO::Lang::Trans.init
class Object

  # I18n
  def t(key, *args); ::GDO::Lang::Trans.instance.translate(key, *args); end

  # Module
  def gdo_module(name); ::GDO::Core::ModuleLoader.instance.module(name); end

  # Reload
  def reload
    if is_a?(::Module)
      begin
        path = name.gsub('::','/')+".rb"
        load(path)
        # ::GDO::Core::Log.debug("Reloaded GDO module #{name} from #{path}")
      rescue LoadError => e
      end
    end
  end
  def self.reload
    if is_a?(::Class)
      begin
        path = name.gsub('::','/')+".rb"
        load(path)
        # ::GDO::Core::Log.debug("Reloaded GDO class #{name} from #{path}")
      rescue LoadError => e
      end
    end
  end
end

####################
### Load plugins ###
####################
# Now load all plugins
#Bundler.setup
#Bundler.load
# require "mysql2"

#########################
### Load Core modules ###
#########################
require "GDO/Core/StringUtil"
require "GDO/Core/Module"
require "GDO/User/Module"
