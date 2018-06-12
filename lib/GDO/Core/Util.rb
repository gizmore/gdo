module GDO::Core
  class Util
    
    def self.each_class(mod=nil, &block)
      mod = ::Object if mod.nil?
      mod.constants.each do |symbol|
        const = mod.const_get(symbol)
        if const.is_a? ::Class
          yield(const)
        elsif const.is_a? ::Module
          each_class(const, &block)
        end
      end
    end

    def self.each_module(mod=nil, &block)
      mod = ::Object if mod.nil?
      mod.constants.each do |symbol|
        const = mod.const_get(symbol)
        if const.is_a? ::Class
        elsif const.is_a? ::Module
          yield(const)
          each_module(const, &block)
        end
      end
    end
    
    def self.each_constant(mod=nil, &block)
      mod = ::Object if mod.nil?
      mod.constants.each do |symbol|
        const = mod.const_get(symbol)
        if (const.is_a? ::Class) || (const.is_a? ::Module)
          yield(const)
          each_constant(const, &block)
        end
      end
    end
    
  end
end