#
#
#
class GDO::DB::Result

  def initialize(result)
    @table = nil
    @result = result
    @enum = result.to_enum
    @cached = false
  end
  
  def finalize
    # TODO: Free result
  end
  
  def table(table); @table = table; self; end
  def cached(cached); @cached = cached; self; end
  
  def num_rows
    byebug
  end
  
  def fetch_var(i=0)
    fetch_row[i]
  end

  def fetch_row
    fetch_assoc.values rescue nil
  end
  
  def fetch_assoc
    @enum.next rescue nil
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
