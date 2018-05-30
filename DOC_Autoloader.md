# GDO Autoloader

The gdo autoloader is very simplistic and thus, hopefully very fast.
It is defined in the main gdo.rb file and looks like this.

    
    def const_missing(const_name)
      path = name.gsub('::', '/') + "/#{const_name}"
      require path
      Object.const_get("#{name}::#{const_name}")
    end


It simply includes the constants in the file system as is, like this:

GDO::User::GDO_User # => load "GDO/User/GDO_User.rb"
