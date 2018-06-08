module GDO::Core
  class StringUtil
    
    
    
  end
end

class String
  
  def substr_to(to, default=nil)
    i = self.index(to)
    i != nil ? self[0,i] : default
  end
  
  def substr_from(from, default=nil)
    i = self.index(to)
    i != nil ? self[i+from.length..-1] : default
  end
  
  def rsubstr_to(to, default=nil)
    i = self.rindex(to)
    i != nil ? self[0,i] : default
  end
  
  def rsubstr_from(from, default=nil)
    i = self.rindex(from)
    i != nil ? self[i+from.length..-1] : default
  end
  
end
