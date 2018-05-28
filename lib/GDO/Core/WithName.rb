module GDO::Core
  module WithName

    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      def name; @name; end
      def with_name(name); @name=name; self; end
    end

    module ClassMethods
      def _default_name
        @@name ||= 0
        @@name += 1
        "gdo#{@@name}"
      end

      def make(name=nil)
        new.with_name(name||_default_name)
      end
    end

  end
end
