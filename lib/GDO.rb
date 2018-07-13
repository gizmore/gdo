 # # # ## # # # 
# # # BOOT # # #
 # # # ## # # #
require "GDO/version"

##################
### Autoloader ###
##################
# Create simple autoloader
module GDO
  module Autoloader
    # Simply include missing constants as is in the file system. e.g.: GDO::Net::GDT_Url  => require "GDO/Net/GDT_Url"
    def const_missing(const_name)
      path = name.gsub('::', '/') + "/#{const_name}"
      require path
      if self.const_defined?("#{const_name}")
        self.const_get("#{const_name}")
      else
        raise ::GDO::Core::Exception.new(t(:err_missing_const, self.name, const_name, path))
      end
      rescue LoadError => e
      ::GDO::Core::Log.error(t(:err_gdo_autoload, name, const_name, path))
      ::GDO::Core::Log.exception(e)
      raise ::GDO::Core::Exception.new(t(:err_autoload_missing_file, path))
      nil
    end
  end
  extend Autoloader # apply to module GDO
end

# Apply this simple autoloader to all gdo core modules
module GDO
  module Admin; extend Autoloader; end
  module Core; extend Autoloader; end
  module Crypto; extend Autoloader; end
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
  module Test; extend Autoloader; end
  module Table; extend Autoloader; end
  module UI; extend Autoloader; end
  module User; extend Autoloader; end
end


# Load Global helpers
require "GDO/Core/StringUtil"
::GDO::Lang::Trans.init('en')

# Monkeypatch basic helpers
class Object

  # Module
  def gdo_module(name); ::GDO::Core::ModuleLoader.instance.get_module(name) or raise ::GDO::Core::Exception(t(:err_unknown_module)); end
  
  # HTML
  def html(string); return nil if string.nil?; string.gsub('<', '&lt;').gsub('>', '&gt;').gsub('"', '&quot;'); end
  
  # MySQL
  def escape(string); ::GDO::Core::GDO.escape(string); end
  def quote(string); ::GDO::Core::GDO.quote(string); end
  
  # URLs
  def href(_module, method, append=''); "/?mo=#{_module}&me=#{method}#{append}"; end
  def url(_module, method, append=''); ::GDO::Net::GDT_Url.gdo_external_url(href(_module, method, append)); end
  
  # Site
  def sitename; t(:sitename); end
  
  # Global Reload
  def reload
    if is_a?(::Module)
      begin
        path = name.gsub('::','/')+".rb"
        load(path)
      rescue LoadError => e
      end
    end
  end
  def self.reload
    if is_a?(::Class)
      begin
        path = name.gsub('::','/')+".rb"
        load(path)
      rescue LoadError => e
      end
    end
  end
end

#########################
### Load Core modules ###
#########################
require "GDO/Core/Module"
require "GDO/DB/Module"
require "GDO/Form/Module"
require "GDO/Install/Module"
require "GDO/User/Module"
require "GDO/Mail/Module"
# require "GDO/Net/Module"
require "GDO/Table/Module"
require "GDO/UI/Module"
