module GDO::DB
  class Connection

    @@queries ||= 0
    @@queries_read ||= 0
    @@queries_write ||= 0
    @@queries_time ||= 0.0

    @@tables ||= {}
    @@columns ||= {}


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

    ###############
    ### Connect ###
    ###############
    def get_link
      if !@link
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
        ::GDO::Core::Log.raw('queries', query)
        @queries += 1
        @@queries += 1
        t1 = Time.new
        result = get_link.query(query)
        t2 = Time.new - t1
        @queries_time += t2
        @@queries_time += t2
        result
      rescue StandardError => e
        ::GDO::Core::Log.error(e.message)
      end
    end

    ###################
    ### Table cache ###
    ###################
    @@tables ||= {}
    def table_for(klass)
      if !@@tables[klass]
        @@tables[klass] = gdo = Object.const_get(klass.name).new
        @@columns[klass] = init_fields(gdo)
      end
      @@tables[klass]
    end

    def columns_for(klass)
      table_for(klass)
      @@columns[klass]
    end

    def init_fields(gdo)
      fields = {}
      gdo.fields.each {|gdt| fields[gdt.name] = gdt}
      fields
    end


  end
end
