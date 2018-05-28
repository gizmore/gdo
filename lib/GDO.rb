require "GDO/version"
require 'mysql2'

require "byebug"


module GDO
  module Autoloader
    def const_missing(const_name)
      path = name.gsub('::', '/') + '/' + const_name.to_s
#      puts "Loading #{path} as #{const_name}"
      require path
#      puts "Returning #{name + '::' + const_name.to_s}"
      Object.const_get(name + '::' + const_name.to_s)
    end
  end
  include Autoloader
end

module GDO
  module Core; extend Autoloader; end
  module Date; extend Autoloader; end
  module DB; extend Autoloader; end
  module File; extend Autoloader; end
  module Form; extend Autoloader; end
  module Install; extend Autoloader; end
  module Lang; extend Autoloader; end
  module Table; extend Autoloader; end
  module UI; extend Autoloader; end
  module User; extend Autoloader; end
end

require "GDO/Core/Module"
require "GDO/User/Module"
