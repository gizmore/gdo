module GDO::Core
  class GDO

    # ENGINE
    MYISAM = "MyISAM"
    INNODB = "InnoDB"
    MEMORY = "Memory"

    def engine; MYISAM; end
    def gdo_cached; false; end
    def mem_cached; false; end
    def fields; []; end

    def initialize
      @gdo_vars = {}
      @dirty_vars = {}
    end

    ################
    ### Escaping ###
    ################
    def self.escapeIdentifier(identifier); identifier.to_s.gsub("`", "\\`"); end
    def self.quoteIdentifier(identifier); "`#{self.escapeIdentifier(identifier)}`"; end
    def self.escapeSearch(searchString); self.escape(searchString).gsub('%', '\\%'); end
    def self.escape(value); value.gsub("'", "\\'").gsub('"', '\\"'); end
    def self.quote(value); "'#{self.escape(value)}'"; end

    ##########
    ### DB ###
    ##########
    def columns; db.columns_for(self.class); end
    def column(name); columns[name].gdo(self); end
    def db; ::GDO::DB::Connection.instance; end
    def self.db; ::GDO::DB::Connection.instance; end
    def self.table; db.table_for(self); end
    def name; self.class.name; end
    def table_name; name.gsub('::', '_'); end

    def init_cache
      @cache = ::GDO::DB::Cache.new(self)
      self
    end

    def get_id
      id = ""
      primary_key_columns.each {|name,gdt| name,gdt
      }
      id[1..-1]
    end

    ##############
    ### Entity ###
    ##############
    # def self.entity(vars)
    #   gdo = self.new
    #   gdo.set_vars(vars)
    # end
    #
    # def self.blank_data(data)
    #
    # end

    def self.blank(data)
      instance = self.new
      instance.columns.each {|k,v|
        if data.has_key?(k)
          instance.set_var(k, data[k], false)
        end
      }
      instance.dirty(true)
    end


    def create_table
      columns = []
      indexes = []
      primary = []
      columns.each {|name,gdt|
        define = gdt.column_define
        columns.push(define) unless define.nil?
        indexes.push(name) if gdt._index
        primary.push(name) if gdt._primary
      }
      query = "CREATE TABLE #{table_name} (\n"
      query += columns.join(",\n")
      query += ")\n"
      query += "ENGINE = #{engine}\n"
      db.query_write(query)
    end

    def query
      ::GDO::DB::Query.new.gdo(self)
    end

    def insert
      query.insert.values(dirty_vars).execute
      after_create
      self
    end

    ###############
    ### Columns ###
    ###############
    def primary_key_columns
      pk = {}
      columns.each {|name,gdt|
        pk[name] = gdt if gdt._primary
      }
      pk
    end

    #################
    ### Selection ###
    #################
    def find(*id)
      get_by_id(id)
    end

    def get_by_id(*id)
      if (!@cache) || (!(gdo = @cache.find_cached(id)))
        i = 0
        query = select
        primary_key_columns.each {|name,gdt|
          query.where("#{gdt.identifier}=#{id[i]}")
          i += 1
        }
        gdo = query.first.execute.fetch_object
      end
      gdo
    end

    def select(fields='*')
      query.select(fields)
    end

    ############
    ### Vars ###
    ############
    def set_var(name, var, mark_dirty=true)
      @gdo_vars[name] = var
      mark_dirty ? set_dirty(name) : self
    end

    def get_var(name)
      @gdo_vars[name]
    end

    def get_vars
      @gdo_vars
    end

    def set_vars(vars)
      @gdo_vars = vars
      dirty
    end

    def get_value(name)
      column(name).to_value(get_var(name))
    end

    def is_dirty?(name)
      (@dirty_vars == true) || (@dirty_vars[name])
    end

    def dirty(dirty=true)
      @dirty_vars = dirty
      self
    end

    def set_dirty(name)
      if @dirty_vars == true
      elsif @dirty_vars == false
        @dirty_vars = { name: @gdo_vars[name] }
      else
        @dirty_vars[name] = @gdo_vars[name]
      end
      self
    end

    def set_clean(name)
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
    def after_create

    end


  end
end