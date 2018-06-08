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
      ::GDO::Core::ModuleLoader.instance.add_module(new.path(File.dirname(path)))
    end
    
  end

end
