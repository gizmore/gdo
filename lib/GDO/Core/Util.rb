module GDO::Core
  class Util
    
    def self.all_classes(mod=nil, &block)
      
      mod = ::Object if mod.nil?
      
      mod.constants.each do |symbol|
        
        const = mod.const_get(symbol)
        if const.is_a? ::Class
          yield(const)
        elsif const.is_a? ::Module
          all_classes(const, &block)
        end
        
      end
      
    end
    
  end
end