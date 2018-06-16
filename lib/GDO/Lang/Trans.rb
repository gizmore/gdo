require 'yaml'
#
module GDO::Lang
  #
  # Very basic I18n class.
  # Should be faster than I18n from rails.
  #
  # @version 1.00
  # @since 1.00
  # @license MIT
  # @author gizmore@wechall.net
  #
  class Trans
    
    include ::GDO::Core::WithInstance
    
    def self.init(iso='en')
      instance.iso(iso)
    end
    
    def iso(iso); @iso = iso.to_s; self; end
    def _iso; @iso; end

    def add_path(path)
      ::GDO::Core::Log.debug("::GDO::Lang::Trans.add_path(#{path})")
      @pathes.push(path)
      @cache = {}
      self
    end

    def initialize
      @iso = 'en'
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

