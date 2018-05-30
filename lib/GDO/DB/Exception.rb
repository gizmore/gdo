module GDO::DB
  # Exception with query parameter
  class Exception < ::GDO::Core::Exception
    
    def query(query); @query = query; self; end
    
    def to_s
      "#{super.to_s} IN\n#{@query}" 
    end
    
  end
end
