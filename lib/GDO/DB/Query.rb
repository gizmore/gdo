#
module GDO::DB
  #
  # GDO Query builder
  #
  # @version 1.00
  # @since 1.00
  # @author gizmore
  #
  class Query

    REPLACE ||= 'REPLACE INTO '
    INSERT ||= 'INSERT INTO '
    UPDATE ||= 'UPDATE '
    SELECT ||= 'SELECT '
    DELETE ||= 'DELETE FROM '

    def initialize
      @write = false
      @type = nil
      @select = nil
      @from = nil
      @limit = nil
      @where = nil
      @join = nil
      @values = nil
      @cached = true
    end
    
    def cached(cached=true); @cached = cached; self; end
    def uncached; cached(false); end

    def select(fields)
      @type = SELECT
      @select += ',' unless @select.nil?
      @select ||= ''
      @select += fields
      @select += " "
      self
    end
    def insert; @type = INSERT; @write = true; self; end
    def update; @type = UPDATE; @write = true; self; end
    def delete; @type = DELETE; @write = true; self; end
    def replace; @type = REPLACE; @write = true; self; end

    def debug(debug); @debug = debug; self; end

    def gdo(gdo); @gdo = gdo; from(gdo.table_name); end

    def from(from); @from = "#{from} "; self; end
    def build_from; @write ? @from : "FROM #{@from} "; end

    def where(where, op='AND')
      if @where
        @where += "#{op} "
      else
        @where = "WHERE "
      end
      @where += "(#{where}) "
      self
    end

    def limit(count, start=0); @limit = "LIMIT #{start}, #{count} "; self; end
    def first; limit(1); end

    def values(values); @values ||= {}; @values.merge!(values); self; end
    def build_values
      return "" unless @values
      gdo = ::GDO::Core::GDO
      if @type == UPDATE
        fields = []
        @values.each {|k,v|
          fields.push("#{gdo.quoteIdentifier(k)}=#{gdo.quote(v)}")
        }
        "SET #{fields.join(',')} "
      else
        fields = []
        values = []
        @values.each {|k,v|
          fields.push(gdo.quoteIdentifier(k))
          values.push(gdo.quote(v))
        }
        "(#{fields.join(',')}) VALUES (#{values.join(',')}) "
      end
    end
    
    def join(join); @join ||= ''; @join += "#{join} "; self; end
    def join_object(field)
      column = @gdo.table.column(field)
      if column.is_a?(::GDO::DB::GDT_Join)
        join(column._join)
      elsif column.is_a?(::GDO::DB::GDT_Object)
        gdo = column._table
        join("JOIN #{gdo.table_name} ON #{gdo.primary_key.identifier}=#{column.identifier}")
      else
        raise ::GDO::Core::Exception.new(t(:err_cannot_join, field))
      end
      
    end

    ############
    ### Exec ###
    ############
    def build
      query = ""
      query += @type
      query += @select if @select
      query += build_from
      query += build_values
      query += @join if @join
      query += @where if @where
      query += @limit if @limit
      query
    end

    def execute
      db = ::GDO::DB::Connection.instance
      query = build
      if @write
        db.query_write(query)
      else
        result = db.query_read(query)
        ::GDO::DB::Result.new(result).table(@gdo).cached(@cached)
      end
    end

  end
end
