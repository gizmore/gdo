#
module GDO::Core
  #
  # GDO is both, an entity and a table object.
  # You create tables by overriding the "fields" method.
  # It returns an array of GDTs.
  # GDT are plugged into GDOs, other GDT like GDT_Form, GDT_Table, Method parameters and more.
  #
  # @see ::GDO::Core::GDT
  #
  # @version 1.00
  # @since 1.00
  # @author gizmore@wechall.net
  #
  class GDO

    #################
    ### Overrides ###
    #################
    # ENGINE
    MYISAM ||= "MyISAM"
    INNODB ||= "InnoDB"
    MEMORY ||= "Memory"
    # Return storage engine for this GDO table
    def engine; INNODB; end

    # Return true to enable gdo backed cache
    def gdo_cached; false; end

    # Return true to enable memcached backed cache
    def mem_cached; false; end

    #
    # Database columns
    # @return Array[::GDO::Core::GDT]
    #
    def fields; []; end

    def initialize
      @gdo_vars = {}
      @dirty_vars = false
      @persisted = false
    end

    def name; self.class.name; end

    ################
    ### Escaping ###
    ################
    def quote(var); self.class.quote(var); end
    def self.escapeIdentifier(identifier); identifier.to_s.gsub("`", "\\`"); end
    def self.quoteIdentifier(identifier); "`#{self.escapeIdentifier(identifier)}`"; end
    def self.escapeSearch(searchString); self.escape(searchString).gsub('%', '\\%'); end
    def self.escape(var); var.to_s.gsub("'", "\\'").gsub('"', '\\"'); end
    def self.quote(var)
      return "'#{self.escape(var)}'" if var.is_a?(String) or var.is_a?(Symbol)
      return "NULL" if var.nil?
      return var if var.is_a?(Numeric)
      return '1' if var == true
      return '0' if var == false
      raise ::GDO::Core::Exception.new(t(:err_cannot_quote, var, var.class.name))
    end

    ##########
    ### DB ###
    ##########
    # Get cached columns from db connection
    # @return {String,::GDO::Core::GDT}
    def columns
      db.columns_for(self.class)
    end
    
    # Get cached column from db connection
    def column(name)
      column = columns[name.to_s]
      raise ::GDO::Core::Exception.new(t(:err_gdo_no_column, self.name, name)) if column.nil?
      column.gdo(self)
    end
    
    # Get db connection
    def db; ::GDO::DB::Connection.instance; end
    # Get db connection
    def self.db; ::GDO::DB::Connection.instance; end
    # Get cached table GDO
    def table; self.class.table; end
    # Get cached table GDO
    def self.table; db.table_for(self); end
    def table_name; name.rsubstr_from('::').downcase; end
    def self.table_name; name.rsubstr_from('::').downcase; end

    def _cache; @cache; end
    def init_cache
      @cache = ::GDO::DB::Cache.new(self)
      self
    end

    def get_id
      id = ""
      primary_key_columns.each {|name,gdt|
        id += ":" unless id.empty?
        id += get_var(name)
      }
      id
    end
    
    ##############
    ### Entity ###
    ##############
    def blank(data); self.class.blank(data); end
    def self.blank(data={})
      instance = self.new
      # blank columns with correct dirty flags
      instance.columns.each {|k,gdt|
        if data.has_key?(k.to_sym)
          instance.set_var(k, data[k.to_sym].to_s, true)
        elsif data.has_key?(k.to_s)
          instance.set_var(k, data[k.to_s].to_s, true)
        else
          instance.set_var(k, gdt._initial, true)
        end
      }
      # remaining, which might not be columns
      data.each{|k,v|
        instance.set_var(k, v, false)
      }
      instance
    end

    ###############
    ### Queries ###
    ###############

    #
    def create_table
      columns = []; indexes = []; uniques = []; primary = []
      # add GDTypes and gather special columns
      self.columns.each {|name,gdt|
        indexes.push(name) if gdt._index
        uniques.push(name) if gdt._unique
        primary.push(name) if gdt._primary
        define = gdt.column_define
        columns.push("#{name} #{define}") unless define.nil?
      }
      # add special columns
      columns.push("PRIMARY KEY(#{primary.join(',')})") unless primary.empty?
      indexes.each {|name| columns.push("INDEX(#{name})") }
      uniques.each {|name| columns.push("UNIQUE(#{name})") }
      # Build query
      query = "CREATE TABLE IF NOT EXISTS #{table_name} (\n"
      query += columns.join(",\n")
      query += ")\n"
      query += "ENGINE = #{engine}\n"
      # Write
      db.query_write(query)
      self
    end

    def drop_table
      db.query_write("DELETE FROM #{table_name}") rescue nil # Trigger cascades
      db.without_foreign_keys do
        db.query_write("DROP TABLE IF EXISTS #{table_name}") # drop afterwards
      end
      self
    end
    
    def truncate_table
      db.query_write("DELETE FROM #{table_name}") rescue nil # Trigger cascades
      db.without_foreign_keys do
        db.query_write("TRUNCATE TABLE #{table_name}") # truncate afterwards
      end
      self
    end

    def query; ::GDO::DB::Query.new.gdo(self); end

    def query_pk
      query = self.query
      primary_key_columns.each {|name,gdt| query.where("#{gdt.identifier}=#{quote(get_var(gdt._name))}") }
      query
    end

    def replace; insert(true); end

    def insert(replace=false)
      query = replace ? self.query.replace : self.query.insert
      query.values(dirty_vars).execute
      dirty(false).persisted
      recache
      after_create
      self
    end

    def save
      if @persisted
        query = query_pk.update.values(dirty_vars)
        before_update(query)
        query.execute
        dirty(false).persisted
        recache
        after_update
        self
      else
        insert
      end
    end
    
    #
    # Delete this row.
    #
    def delete
      # Can only delete persisted rows
      raise ::GDO::DB::Exception.new(t(:err_delete_unpersisted, name)) unless @persisted
      # DB query
      query_pk.delete.execute
      # Uncache
      table = self.table
      table._cache.uncache_id(get_id) if table._cache
      # Dirty and persisted flags
      persisted(false)
      dirty(true)
    end
    
    # Return a delete query
    # @return ::GDO::DB::Query
    def delete_query
      table.query.delete
    end

    def recache
      table = self.table
      table._cache.recache(self) if table._cache
      self
    end
    
    ###############
    ### Columns ###
    ###############
    def primary_key
      primary_key_columns.first[1]
    end
    
    def primary_key_columns
      pk = {}
      columns.each {|name,gdt|
        pk[name] = gdt if gdt._primary || gdt.is_a?(::GDO::DB::GDT_AutoInc)
      }
      pk
    end
    
    #################
    ### Selection ###
    #################
    def find!(id)
      find(id) or raise ::GDO::Core::Exception.new(t(:err_row_not_found))
    end

    def find(id)
      get_by_id(id)
    end

    def get_by_id(id)
      id = id.to_s
      if (!@cache) || (!(gdo = @cache.find_cached(id)))
        i = 0
        query = select
        ids = id.split(':')
        primary_key_columns.each {|name,gdt|
          query.where("#{gdt.identifier}=#{::GDO::Core::GDO.quote(ids[i])}")
          i += 1
        }
        gdo = query.first.execute.fetch_object
        gdo.recache unless gdo.nil?
      end
      gdo
    end

    def select(fields='*')
      query.select(fields)
    end
    
    def get_where(where)
      select().where(where).limit(1).execute.fetch_object
    end
    
    def find_where(where)
      get_where(where) or raise ::GDO::Core::Exception.new(t(:err_row_not_found))
    end
    
    def get_by(hash)
      where = ""
      hash.each{|field,value|
        where += " AND " unless where.empty?
        where += "#{field.to_s}=#{::GDO::Core::GDO.quote(value)}"
      }
      get_where(where)
    end
    
    def find_by(hash)
      get_by(hash) or raise ::GDO::Core::Exception.new(t(:err_row_not_found))
    end

    ############
    ### Vars ###
    ############
    def persisted(persisted=true); @persisted = persisted; self; end
    def persisted?; @persisted; end

    def set_var(name, var, mark_dirty=true)
      @gdo_vars[name.to_s] = var.to_s.empty? ? nil : var.to_s
      mark_dirty ? set_dirty(name) : self
    end

    def set_value(name, value, mark_dirty=true)
      var = column(name).to_var(value)
      set_var(name, var, mark_dirty)
    end

    def get_var(name)
      @gdo_vars[name.to_s]
    end

    def get_value(name)
      column(name.to_s).to_value(get_var(name.to_s))
    end

    def get_vars
      @gdo_vars
    end

    def set_vars(vars, dirty=true)
      @gdo_vars = vars
      dirty ? self.dirty : self
    end
    
    def save_var(name, var)
      set_var(name, var)
      save
    end
    
    def save_vars(vars)
      vars.each{|key, var| set_var(key, var) }
      save
    end
    
    def save_value(name, value)
      var = column(name).to_var(value)
      save_var(name, var)
    end

    ###################
    ### Dirty flags ###
    ###################
    def is_dirty?(name)
      (@dirty_vars == true) || (@dirty_vars[name])
    end

    def dirty(dirty=true)
      @dirty_vars = dirty
      self
    end

    def set_dirty(name)
      name = name.to_s
      if @dirty_vars == true
      elsif @dirty_vars == false
        @dirty_vars = { name => @gdo_vars[name] }
      else
        @dirty_vars[name] = @gdo_vars[name]
      end
      self
    end

    def set_clean(name)
      name = name.to_s
      if @dirty_vars == true
        @dirty_vars = {}
        columns.each {|k,gdt| @dirty_vars[name] = true unless name == k }
      elsif @dirty_vars == false
      else
        @dirty_vars.delete(name)
      end
      self
    end

    def dirty_vars
      if @dirty_vars == true
        @gdo_vars
      elsif @dirty_vars == false
        {}
      else
        @dirty_vars
      end
    end

    ##############
    ### Events ###
    ##############
    def before_create; columns.each{|name,gdt| gdt.before_create(self) }; end
    def after_create; columns.each{|name,gdt| gdt.after_create(self) }; end
    def before_update(query); columns.each{|name,gdt| gdt.before_update(self, query) }; end
    def after_update; columns.each{|name,gdt| gdt.after_update(self) }; end


  end
end