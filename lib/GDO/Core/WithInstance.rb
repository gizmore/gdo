module GDO::Core::WithInstance

  def instance
    if class_variable_defined?('@@gdo_instance')
      class_variable_get('@@gdo_instance')
    else
      instance = self.new
      class_variable_set('@@gdo_instance', instance)
      instance
    end
  end

end