module GDO::DB
  class Result

    def initialize(result)
      @table = nil
      @result = result
      @enum = result.to_enum
      @cached = false
    end
    
    ### TODO: Destructor with mysqli_free_result
    
    def table(table); @table = table; self; end
    def cached(cached); @cached = cached; self; end
    
    def num_rows; byebug; end
    
#   
  # #############
  # ### Fetch ###
  # #############
  # public function fetchValue()
  # {
    # if ($row = $this->fetchRow())
    # {
      # return $row[0];
    # }
  # }
  
  # public function fetchRow()
  # {
    # return mysqli_fetch_row($this->result);
  # }
#   
  # public function fetchAllRows()
  # {
    # $allRows = [];
    # while ($row = mysqli_fetch_row($this->result))
    # {
      # $allRows[] = $row;
    # }
    # return $allRows;
  # }
#   
#   
  # /**
   # * @return string[]
   # */
  # public function fetchAssoc()
  # {
    # return mysqli_fetch_assoc($this->result);
  # }
#   
  # public function fetchAllAssoc()
  # {
    # $data = [];
    # while ($row = $this->fetchAssoc())
    # {
      # $data[] = $row;
    # }
    # return $data;
  # }
#   
  # /**
   # * @return GDO
   # */
  # public function fetchObject()
  # {
    # return $this->fetchAs($this->table);
  # }
  
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
    return table.blank(vars).persisted
  end
  
#   
  # /**
   # * @param GDO $table
   # * @return GDO
   # */
  # public function fetchAs(GDO $table)
  # {
    # if ($gdoData = $this->fetchAssoc())
    # {
      # if ($this->useCache && $table->gdoCached())
      # {
        # return $table->initCached($gdoData);
      # }
      # else
      # {
        # $class = $table->gdoClassName();
        # $object = new $class();
        # $object instanceof GDO;
        # return $object->setGDOVars($gdoData)->setPersisted();
      # }
    # }
  # }
# 
  # /**
   # * @return GDO[]
   # */
  # public function fetchAllObjects($json=false)
  # {
    # return $this->fetchAllObjectsAs($this->table, $json);
  # }
#   
  # /**
   # * @return GDO[]
   # */
  # public function fetchAllObjectsAs(GDO $table, $json=false)
  # {
    # $objects = [];
    # while ($object = $this->fetchAs($table, $json))
    # {
      # $objects[] = $json ? $object->toJSON() : $object;
    # }
    # return $objects;
  # }
# 
  # /**
   # * Fetch all 2 column rows as a 0 => 1 assoc array.
   # * @return string[]
   # */
  # public function fetchAllArray2dPair()
  # {
    # $array2d = [];
    # while ($row = $this->fetchRow())
    # {
      # $array2d[$row[0]] = $row[1];
    # }
    # return $array2d;
  # }
#   
  # public function fetchAllArray2dObject(GDO $table=null, $json=false)
  # {
      # $table = $table ? $table : $this->table;
      # $array2d = [];
      # while ($object = $this->fetchAs($table))
      # {
          # $array2d[$object->getID()] = $json ? $object->toJSON() : $object;
      # }
      # return $array2d;
  # }
#   
  # public function fetchAllArrayAssoc2dObject(GDO $table=null)
  # {
    # $table = $table ? $table : $this->table;
    # $array2d = [];
    # $firstKey = '';
    # while ($object = $this->fetchAs($table))
    # {
        # $firstKey = $firstKey ? $firstKey : array_keys($object->getGDOVars())[0];
        # $array2d[$object->getVar($firstKey)] = $object;
    # }
    # return $array2d;
  # }
#   
    # /**
   # * Fetch all, but only a single column as simple array.
   # * @return string[]
   # */
  # public function fetchAllValues()
  # {
    # $values = [];
    # while ($value = $this->fetchValue())
    # {
      # $values[] = $value;
    # }
    # return $values;
  # }
#   
  # ############
  # ### JSON ###
  # ############
  # /**
   # * @param GDT[] $headers
   # * @return string[]
   # */
  # public function renderJSON(array $headers)
  # {
    # $data = [];
    # while ($gdo = $this->fetchObject())
    # {
      # $row = [];
      # foreach($headers as $gdoType)
      # {
        # $row[] = $gdoType->gdo($gdo)->gdoRenderCell();
      # }
      # $data[] = $row;
    # }
    # return $data;
  # }
# }

  end
end