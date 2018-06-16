module GDO::Core::WithFields

  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def fields
      []
    end
    
    def _fields
      @fields ||= fields
    end
    
    def add_field(field)
      _fields.push(field)
      self
    end
    
    def add_fields(*fields)
      _fields << fields
      self
    end


    def field(field)
      _fields.each{|gdt| return gdt if gdt._name == field.to_s }
      raise ::GDO::Core::Exception.new(t(:err_unknown_field, field, self.class.name))
    end

    def set_var(field, var)

    end

    def set_value(field, value)

    end

    def get_var(field)

    end

    def get_value(field)

    end
    
    def fields_of(klass)
      _fields.select{|gdt|
        gdt.is_a?(klass)
      }
    end

  end

  module ClassMethods

  end


end