#
#
#
class GDO::UI::GDT_Anchor < GDO::UI::GDT_Label
  
  ###############
  ### Factory ###
  ###############
  def self.make_href(module_name, method_name, append=nil)
    make_url(module_name, method_name, append).anchor_local
  end
  
  def self.make_url(module_name, method_name, append=nil)
    new.
      anchor_module(module_name).
      anchor_method(method_name).
      anchor_query(append)
  end
  
  # Get method instance
  def anchor_method
    gdo_module(@anchor_module).gdo_method(@anchor_method)
  end
  
  ###########
  ### GDT ###
  ###########
  def _href; @href; end
  def href(href); @href = href; self; end
  
  def _target; @target || '_self'; end
  def target(target); @target = target; self; end
  def target_blank; target('_blank'); end
  
  def _anchor_module; @anchor_module; end
  def anchor_module(module_name); @anchor_module = module_name; self; end

  def _anchor_method; @anchor_method; end
  def anchor_method(method_name); @anchor_method = method_name; self; end
  
  def _anchor_query; @anchor_query; end
  def anchor_query(query); @anchor_query = query; self; end
  
  def _anchor_local; @anchor_local; end
  def anchor_local(local=true); @anchor_local = local; self; end
  
  ############
  ### HREF ###
  ############
  def html_href
    @href ||= gdo_href
  end
  
  def gdo_href
    append = @anchor_query == nil ? '' : "&#{@anchor_query}"
    url = "/?mo=#{@anchor_module}&me=#{@anchor_method}#{append}"
    @anchor_local ? url : ::GDO::Net::GDT_Url.external_gdo_href(url)
  end
  
  ##############
  ### Render ###
  ##############
  def render_html; ::GDO::Core::GDT_Template.render_template('UI', 'gdt_anchor.erb', field: self); end

end

