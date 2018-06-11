module GDO::Core::WithInstance
  
  include ::GDO::Core::WithEvents

  def instance
    if class_variable_defined?('@@gdo_instance')
      class_variable_get('@@gdo_instance')
    else
      instance = self.new
      instance_set(instance)
    end
  end
  
  def instance_set(instance)
    class_variable_set('@@gdo_instance', instance)
    instance
  end
  
  subscribe(:gdo_cache_flush) do
    
    
    ::GDO::Core::Util.all_classes(::GDO) do |klass|
      puts klass.to_s
      klass.remove_class_variable('@@gdo_instance') if klass.class_variable_defined?('@@gdo_instance')
    end
  end
  
    
    

end
