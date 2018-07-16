#
#
#
class GDO::DB::ArrayResult

  def initialize(data)
    @data = data
    @pointer = 0
    @table = nil
  end
  
  def table(table); @table = table; self; end
  
  def num_rows
    @data.length
  end
  
  def fetch_var(i=0)
    fetch_row[i]
  end

  def fetch_row
    fetch_assoc.values rescue nil
  end
  
  def fetch_assoc
    data = @data[@pointer] rescue nil
    @pointer += 1
    data
  end
  
  def fetch_object
    fetch_as(@table)
  end
  
  def fetch_as(table)
    return nil unless vars = fetch_assoc
    return table._cache.init_cached(vars) if @cached && table.gdo_cached
    return table.blank(vars).dirty(false).persisted
  end

end
