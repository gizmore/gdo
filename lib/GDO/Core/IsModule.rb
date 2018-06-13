module GDO::Core::IsModule

  def self.included(klass)
    klass.include InstanceMethods
    klass.extend ClassMethods
  end

  module InstanceMethods
    
    def path(path); @path = path; self; end
    def _path; @path; end
    
  end

  module ClassMethods

    def is_module(path)
      raise ::GDO::Core::Exception.new("A GDO Module has to be named Module: "+self.name) if self.name.rsubstr_from('::') != 'Module'
      ::GDO::Core::Log.info("Added GDO Module: #{name} in #{path}")
      ::GDO::Core::ModuleLoader.instance.add_module(instance.path(File.dirname(path)))
    end
    
  end

end
