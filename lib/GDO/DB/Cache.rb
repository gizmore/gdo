module GDO::DB
  class Cache
    
    include ::GDO::Core::WithEvents

    def self.get(key); end
    def self.set(key, value); end
    def self.remove(key); end
    def self.delete(key); end
    def self.flush; end

    def self.init()

    end

    def initialize(gdo)
      @gdo = gdo
      @cache = {}
      @dummy = nil
      subscribe(:gdo_cache_flush) do
        @cache = {}
        @dummy = nil
      end
    end

    def dummy
      @dummy ||= @gdo.class.blank
    end
    
    def klass
      @gdo.table_name
    end

    def find_cached(id)
      if !@cache[id]
        if memcached = self.class.get(klass + id)
          @cache[id] = memcached
        end
      end
      @cache[id]
    end

    def recache(gdo)
      if gdo.gdo_cached
        @cache[gdo.get_id] = gdo
      end
      if gdo.mem_cached
#        self::$MEMCACHED->replace(GWF_MEMCACHE_PREFIX.$object->gkey(), $object, GWF_MEMCACHE_TTL);
      end
    end

    def uncache(gdo)
      uncache_id(gdo.get_id)
    end

    def uncache_id(id)
      @cache.delete(id)
#      self::$MEMCACHED->delete(GWF_MEMCACHE_PREFIX.$className . $id);
    end

    def init_cached(vars)
      dummy.set_vars(vars)
      id = dummy.get_id
      if !@cache[id]
        @cache[id] = dummy.persisted
        @dummy = nil
      end
      @cache[id]
    end

    def init_gdo_memcached(vars)
      dummy.set_vars(vars)
      id = dummy.get_id
      if !@cache[id]
        gkey = dummy.gkey
        if (!(gdo = self.class.get(gkey)))
          gdo = dummy.persisted
          self.class.set(gkey, gdo)
          @dummy = nil
          @cache[id] = gdo
        end
      end
      @cache[id]
    end

  end
end
