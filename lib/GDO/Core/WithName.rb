module GDO::Core
  module WithName

    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      def _name; @name; end
      def name(name); @name=name.to_s; self; end
    end

    module ClassMethods
      def _default_name
        @@name ||= 0
        @@name += 1
        "gdo#{@@name}"
      end

      def make(name=nil)
        new.name(name||_default_name)
      end
    end

  end
end
