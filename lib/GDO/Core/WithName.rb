module GDO::Core
  module WithName

    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      ### Name
      def _name; @name; end
      def name(name); @name = name.to_s; self; end
      
      ### Label
      def _label; @label; end
      def label(label); @label = label.to_s; self; end
    end

    module ClassMethods
      def default_name
        @@name ||= 0
        @@name += 1
        "gdo#{@@name}"
      end
      
      def default_label; nil; end

      ###############
      ### Factory ###
      ###############
      def make(name=nil)
        instance = new.name(name||default_name)
        instance.label(default_label)
      end
    end

  end
end
