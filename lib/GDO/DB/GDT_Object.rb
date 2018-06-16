module GDO::DB
  class GDT_Object < ::GDO::DB::GDT_UInt
    
    def initialize
      super
      @cascade = "CASCADE"
      @table = nil
      @on = nil
    end
    
    def _table; @table; end
    def table(table); @table = table; self; end
    
    def _on; @on; end
    def on(on); @on = on; self; end
    
    def _cascade; @cascade; end
    def cascade; @cascade = "CASCADE"; self; end
    def nullify; @cascade = "SET NULL"; self; end
    
    
    def column_define
      
      raise ::GDO::Core::Exception.new(t(:err_gdt_object_no_table, _name)) if @table.nil?
      
      pk = @table.table.primary_key
      raise ::GDO::Core::Exception.new(t(:err_gdt_object_no_pk, @table.name)) if pk.nil?

      define = pk.column_define
      define.gsub!(pk.identifier, identifier)
      define.gsub!(' NOT NULL', '')
      define.gsub!(' PRIMARY KEY', '')
      define.gsub!(' AUTO_INCREMENT', '')
      define.gsub!(/,FOREIGN KEY .* ON UPDATE CASCADE/, '')
      
      on = @on == nil ? pk.identifier : @on
      
      "#{define} #{column_define_null},\n" +
      "FOREIGN KEY (#{identifier}) REFERENCES #{@table.table_name}(#{on}) ON DELETE #{@cascade} ON UPDATE CASCADE"
    end
    
    
  end
end
