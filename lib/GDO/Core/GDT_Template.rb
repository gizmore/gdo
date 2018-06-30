#
# Template engine embedded in a GDT.
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Core::GDT_Template < GDO::Core::GDT

  ###########
  ### GDT ###
  ###########
  # template path
  def _tpath; @tpath; end
  def tpath(tpath); @tpath = tpath; self; end
  
  # template module
  def _tmod; @tmod; end
  def tmod(tmod); @tmod = tmod; self; end

  # template vars
  def _tvars; @tvars||={field:self}; end
  def tvars(tvars); @tvars=nil; _tvars.merge!(tvars); self; end
  def tvar(key, value); _tvars[key.to_s] = value; self; end

  ##############
  ### Render ###
  ##############
  def render; render_html; end
  def render_html
    self.class.render_template(@tmod, @tpath, _tvars)
  end

  ################
  ### Renderer ###
  ################
  #
  # Render a template.
  #
  def self.render_template(mod, path, vars={})
    _mod = gdo_module(mod)
    pathes = []
    
    # Theme pathes first
    ::GDO::Core::Module.instance.cfg_themes.each do |theme,_path|
      pathes.push("#{_path}/#{mod}/tpl/#{path}")
    end
    
    # module path last
    pathes.push("#{_mod._path}/tpl/#{path}")
    
    # Try them
    pathes.each do |_path|
      if ::File.file?(_path)
        return _erb_with_path(_path, vars)
      end
    end
    
    # None found
    raise ::GDO::Core::Exception.new(t(:err_unknown_template, pathes.last))
  end

  #
  # Render a file with vars
  #
  def self._erb_with_path(path, vars={})
    _erb(::File.read(path), vars)
    rescue Exception => e
      GDO::Core::Log.error("Error in template #{path}")
      raise e
  end
  
  # Render a string with vars
  def self._erb(template, vars={})
    ERB.new(template).result_with_hash(vars)
  end

end
