module GDO::Core::IsModule

  def self.included(klass)
    klass.include InstanceMethods
    klass.extend ClassMethods
  end

  module InstanceMethods

  end

  module ClassMethods

    def is_module(path)
      path(path)

    end

  end

end
