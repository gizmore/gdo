#
# @event :gdo_include_assets
#
class GDO::UI::GDT_WebPage < GDO::UI::GDT_Container
  
  include GDO::Core::WithInstance
  include GDO::Core::WithFields
  include GDO::Core::WithEvents
  
  def initialize(name=nil)
    super
    @title = 'GDO6'
    @keywords = []
    @javascripts = []
  end
  
  def _title; @title ||= ''; end
  def title(title); @title = title; self; end
  
  def _keywords; @keywords; end
  def keyword(keyword); k = keywords.trim.downcase; @keywords.push(k) unless @keywords.include?(k); end
  def keywords(keywords); keywords.split(',').each do |keyword| self.keyword(keyword); end; end
  
  def _javascripts; @javascripts; end
  def javascript(path); @javascripts.push(path); end
  
  def _response; @response; end
  def response(response); @response = response; self; end
  
  def render_html
    publish(:gdo_include_assets, self)
    render_template('gdt_webpage.erb', page: self, response: @response)
  end
  
end
