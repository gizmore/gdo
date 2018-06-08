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

    def field(field)
      @fields[field]
    end

    def set_var(field, var)

    end

    def set_value(field, value)

    end

    def get_var(field)

    end

    def get_value(field)

    end

  end

  module ClassMethods

  end


end