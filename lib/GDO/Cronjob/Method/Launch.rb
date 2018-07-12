class GDO::Cronjob::Method::Launch < GDO::Method::Base
  
  def permission; "admin"; end
  
  def execute
    
    modules = ::GDO::Core::ModuleLoader.instance.get_modules
    
    modules.each do |mod|
      mod.methods.each do |method|
        if method.is_a? ::GDO::Method::Cronjob
          method.execute
        end
      end
    end
    
  end
  
end