module GDO::DB
  class Connection
    
    extend ::GDO::Core::WithEvents

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
      
      # No cached link?
      if !@link
        begin
          t1 = Time.new
          @link = ::Mysql2::Client.new(
              host: @hostname,
              username: @username,
              password: @password,
              database: @database,
              reconnect: false,
          )
          t2 = Time.new - t1
          @queries_time += t2
          @@queries_time += t2
        rescue StandardError => e
          ::GDO::Core::Log.exception(e)
          raise ::GDO::DB::Exception.new(e.to_s).query("GDO connection failure.")
        end
        query("SET NAMES utf8")
     end
     
     # Cached link
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

    #
    # Query the database.
    # Rety once on error to reconnect.
    #
    def query(query)

      begin
        retries ||= 0
        # might connect
        link = get_link
        
        # stats begin
        @queries += 1 
        @@queries += 1
        t1 = Time.new

        # Actual query
        result = link.query(query, cast:false)

        # stats end
        t2 = Time.new - t1
        @queries_time += t2
        @@queries_time += t2
        
        # log
        if @debug
          ::GDO::Core::Log.raw('queries', "#{@@queries} (#{t2}s): #{query}")
        end
        
        # yay result
        result
        
      rescue Mysql2::Error => e
        @link = nil
        retry if (retries += 1) <= 1
        ::GDO::Core::Log.exception(e) # Workaround
        raise ::GDO::DB::Exception.new(e.to_s).query(query) # turn to GDO::DB::Exception

      rescue StandardError => e
        ::GDO::Core::Log.exception(e) # log MySQL2 exception
        raise ::GDO::DB::Exception.new(e.to_s).query(query) # turn to GDO::DB::Exception
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
    
    ####################
    ### Foreign Keys ###
    ####################
    def foreign_keys(bool=true)
      bool = bool ? "1" : "0"
      query("SET FOREIGN_KEY_CHECKS=#{bool}")
    end
    
    def without_foreign_keys(&block)
      begin
        foreign_keys(false)
        yield
      ensure
        foreign_keys(true)
      end
    end
    
  end
end
