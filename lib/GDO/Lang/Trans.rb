require 'yaml'
#
# Very basic I18n class.
# Should be faster than I18n from rails.
# This class monkeypatches Object at the bottom of this file!
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Lang::Trans
  
  #
  include ::GDO::Core::WithInstance
  #
  
  ###############
  ### Factory ###
  ###############
  DEFAULT_ISO ||= 'en'
  def self.init(iso=DEFAULT_ISO); instance.iso(iso); end
  def iso(iso); @iso = iso.to_s; self; end
  def _iso; @iso; end

  def initialize
    @iso = DEFAULT_ISO
    @pathes = []
    @cache = {}
  end

  def add_path(path)
    ::GDO::Core::Log.debug("::GDO::Lang::Trans.add_path(#{path})")
    @pathes.push(path)
    @cache = {}
    self
  end

  ##################
  ### Translator ###
  ##################
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
  
  #############
  ### Cache ###
  #############
  private
  
  def reload(iso)
    @cache[iso] ||= {}
    return @cache[iso] if iso == 'bot'
    return @cache[iso] unless @cache[iso].empty?
    _reload(iso)
  end
  
  private
  
  def _reload(iso)
    @pathes.each {|path|
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

#
# Monkeypatch Object with I18n
#
class Object

  # I18n
  def t(key, *args); ::GDO::Lang::Trans.instance.translate(key, *args); end
  def tiso(iso, key, *args); ::GDO::Lang::Trans.instance.translate_iso(iso, key, *args); end
  
  # Times, dates and durations
  def tt(time, format=:short); '13:37'; end
  def ttiso(iso, time, format=:short); '13:37'; end

end
