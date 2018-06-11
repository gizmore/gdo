module GDO::DB
  class Connection
    
    include ::GDO::Core::WithEvents

    @@queries ||= 0
    @@queries_read ||= 0
    @@queries_write ||= 0
    @@queries_time ||= 0.0

    def self.instance; @@instance; end

    def initialize(hostname, username, password, database, debug=true)
      @hostname = hostname
      @username = username
      @password = password
      @database = database
      @debug = debug
      @link = nil
      @queries = 0
      @queries_read = 0
      @queries_write = 0
      @queries_time = 0.0
      @@instance = self
    end

    subscribe(:gdo_cache_flush) do
      flush
    end

    ###############
    ### Connect ###
    ###############
    def get_link
      if !@link
        begin
          t1 = Time.new
          @link = ::Mysql2::Client.new(
              host: @hostname,
              username: @username,
              password: @password,
              database: @database,
              reconnect: true,
          )
          t2 = Time.new - t1
          @queries_time += t2
          @@queries_time += t2
        rescue StandardError => e
          ::GDO::Core::Log.exception(e)
          raise ::GDO::DB::Exception.new(e.to_s).query("GDO connection failure.")
        end
        query("SET NAMES UTF8")
     end
      @link
    end

    ###################
    ### Query logic ###
    ###################
    def query_read(query)
      @queries_read += 1
      @@queries_read += 1
      query(query)
    end

    def query_write(query)
      @queries_write += 1
      @@queries_write += 1
      query(query)
    end

    def query(query)
      begin
        @queries += 1
        @@queries += 1
        t1 = Time.new
        result = get_link.query(query, cast:false)
        t2 = Time.new - t1
        @queries_time += t2
        @@queries_time += t2

        ::GDO::Core::Log.raw('queries', "#{@@queries} (#{t2}s): #{query}") if @debug

        result
      rescue StandardError => e
        ::GDO::Core::Log.exception(e)
        raise ::GDO::DB::Exception.new(e.to_s).query(query)
      end
    end
    
    ############
    ### Util ###
    ############
    def insert_id
      get_link.last_id
    end

    ###################
    ### Table cache ###
    ###################
    @@tables ||= {}
    @@columns ||= {}
    def self.flush; @@tables = {}; @@columns = {}; end

    def table_for(klass)
      if !@@tables[klass]
        @@tables[klass] = gdo = Object.const_get(klass.name).new
        @@columns[klass] = init_fields(gdo)
        gdo.init_cache if gdo.gdo_cached
      end
      @@tables[klass]
    end

    def columns_for(klass)
      table_for(klass)
      @@columns[klass]
    end

    def init_fields(gdo)
      fields = {}
      gdo.fields.each{ |gdt| fields[gdt._name.to_s] = gdt }
      fields
    end
    
    ###
    
  end
end
