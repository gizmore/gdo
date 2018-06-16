#
# Own "WithInstance" decorator.
# @since 1.00
#
module GDO::Core::WithInstance
  
  include ::GDO::Core::WithEvents
  extend ::GDO::Core::WithEvents
  
  def self.included(base)
    ::GDO::Core::Log.debug("GDO::Core::WithInstance::included for #{base}... extending...")
    base.extend self
  end

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

  #
  # On a cache flush we remove all WithInstance instances
  # @see ::GDO::Core::WithEvents
  #
  subscribe(:gdo_cache_flush) do
    ::GDO::Core::Util.each_class(::GDO) do |klass|
      if klass.class_variable_defined?('@@gdo_instance')
        klass.remove_class_variable('@@gdo_instance')
      end
    end
  end

end
