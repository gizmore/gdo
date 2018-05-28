module GDO::DB
  class Query

    REPLACE = 'REPLACE INTO '
    INSERT = 'INSERT INTO '
    UPDATE = 'UPDATE '
    SELECT = 'SELECT  '
    DELETE = 'DELETE '

    def initialize
      @write = false
      @type = nil
      @select = nil
      @from = nil
      @limit = nil
      @where = nil
      @values = nil
    end

    def select(fields)
      @type = SELECT
      @select += ',' unless @select.nil?
      @select ||= ''
      @select += fields
      self
    end
    def insert; @type = INSERT; @write = true; self; end
    def update; @type = UPDATE; @write = true; self; end
    def delete; @type = DELETE; @write = true; self; end
    def replace; @type = REPLACE; @write = true; self; end

    def debug(debug); @debug = debug; self; end

    def gdo(gdo); @gdo = gdo; from(gdo.table_name); end

    def from(from); @from ||= ' FROM '; @from += " #{from}"; self; end

    def where(where, op='AND')
      if @where
        where += " #{op} "
      else
        @where = " WHERE "
      end
      where += "(#{where})"
      self
    end

    def limit(count, start=0); @limit = " LIMIT #{start}, #{count}"; self; end
    def first; limit(1); end

    def values(values); @values ||= {}; @values.merge!(values); self; end
    def build_values
      return "" unless @values
      fields = []
      values = []
      @values.each {|k,v|
        fields.push(::GDO::Core::GDO.quoteIdentifier(k))
        values.push(::GDO::Core::GDO.quote(v))
      }
      " (#{fields.join(',')}) VALUES (#{values.join(',')})"
    end

    ############
    ### Exec ###
    ############
    def build
      query = ""
      query += @type
      query += @from
      query += build_values
      query += @limit if @limit
    end

    def execute
      db = ::GDO::DB::Connection.instance
      query = build
      if @write
        db.query_write(query)
      else
        result = db.query_read(query)

      end
    end

  end
end
