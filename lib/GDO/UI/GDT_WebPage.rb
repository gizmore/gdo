#
# @event :gdo_include_assets
#
class GDO::UI::GDT_WebPage < GDO::UI::GDT_Container
  
  include GDO::Core::WithInstance
  include GDO::Core::WithFields
  include GDO::Core::WithEvents
  
  def initialize(name=nil)
    super
    @title = t(:RUBYGDO, "1.00")
    @keywords = []
    @javascripts = []
    @css = []
    @assets = []
  end
  
  def _title; @title; end
  def title(title); @title = title; self; end
  
  def _keywords; @keywords; end
  def keyword(keyword); k = keywords.trim.downcase; @keywords.push(k) unless @keywords.include?(k); self; end
  def keywords(keywords); keywords.split(',').each do |keyword| self.keyword(keyword); end; self; end
  
  def _response; @response; end
  def response(response); @response = response; self; end
#   
  def render_html
    ::GDO::Core::GDT_Template.render_template('UI', 'gdt_webpage.erb', page: self, response: @response)
  end

  ##############
  ### Assets ###
  ##############
  def _javascripts; @javascipts; end
  def add_js(path)
    @javascripts.push(path)
  end
  def _css; @css; end
  def add_css(path)
    @css.push(path)
  end
  def _assets; @assets; end
  def add_asset(path)
    @assets.push(path)
  end
  def render_css
    
  end
  def render_javascript
    
  end
end
