module GDO::Core::IsModule

  # def self.included(base)
    # ::GDO::Core::Log.debug("GDO::Core::IsModule::included#{base} ... setting up...")
    # base.include InstanceMethods
    # base.extend ClassMethods
  # end

  # module InstanceMethods
#     
    # def path(path); @path = path; self; end
    # def _path; @path; end
#     
  # end

  # module ClassMethods

    def is_module(path)
      # Debug
      raise ::GDO::Core::Exception.new("A GDO Module has to be named Module: "+self.name) if self.name.rsubstr_from('::') != 'Module'
      ::GDO::Core::Log.info("Adding GDO Module: #{name} in #{path}")
      
      # Add Methods module with autoloader to this module class
      mod = instance
      package = mod.module_package
      unless package.constants.include?(:Method)
        methods = ::Module.new
        methods.extend(::GDO::Autoloader)
        package.const_set(:Method, methods)
      end
      
      # Add to cache
      ::GDO::Core::ModuleLoader.instance.add_module(mod.path(File.dirname(path)))
    end
    
  # end

end
