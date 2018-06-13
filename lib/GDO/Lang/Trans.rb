require 'yaml'

module GDO::Lang
  class Trans

    def self.instance; @@instance; end
    
    def self.init
      new
    end
    
    def iso(iso); @iso = iso.to_s; self; end
    def _iso; @iso; end

    def add_path(path)
      ::GDO::Core::Log.info("::GDO::Lang::Trans.add_path(#{path})")
      @pathes.push(path)
      @cache = {}
      self
    end

    def initialize
      @iso = 'en'
      @@instance = self
      @pathes = []
      @cache = {}
    end

    def translate(key, *args)
      translate_iso(@iso, key, *args)
    end
    
    def translate_iso(iso, key, *args)
      reload(iso)
      key = key.to_s
      if text = @cache[iso][key]
        sprintf(text, *args) rescue @cache[iso][key] + args.to_s
      else # Fallback key + printargs
        text = key + args.to_s
      end
    end
    
    def reload(iso)
      @cache[iso] ||= {}
      return @cache[iso] unless @cache[iso].empty?
      @pathes.each {|path|
        path = 
        if File.file?("#{path}_#{iso}.yml")
          path = "#{path}_#{iso}.yml"
        else
          path = "#{path}_en.yml"
        end
        trans = YAML.load_file(path)
        @cache[iso].merge!(trans)
      }
      @cache[iso]
    end

  end
end

