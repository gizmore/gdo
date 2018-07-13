class GDO::Method::GDT_Response < ::GDO::Core::GDT
  
  include ::GDO::Core::WithFields
  
  def self.make_with(*gdts)
    instance = new
    gdts.each{|gdt| instance.add_field(gdt) }
    instance
  end
  
  ###############
  ### Headers ###
  ###############
  def _headers; @headers ||= {}; end
  def headers(headers); @headers = headers; self; end
  def header(key, value=nil); return _headers[key] if value.nil?; _headers[key.to_s] = value; self; end
  ###########
  ### GDT ###
  ###########
  def _code; @code ||= 200; end 
  def code(code); @code = code; self; end
  
  # TODO: Cycle fields for first exception!
  def _exception; _fields[0]._exception rescue nil; end
  
  def _pageless; @pageless; end
  def pageless(pageless=true); @pageless = pageless; self; end
  
  def _filestream; @filestream; end
  def filestream(filepath); @filestream = filepath; self; end
  
  #########################
  ### HTTP Content Type ###
  #########################
  def page_raw
    header('Content-Type', 'text/plain')
    pageless
  end
  
  def page_html
    header('Content-Type', 'text/html')
    pageless(false)
  end
  
  def page
    ::GDO::UI::GDT_WebPage.instance.response(self)
  end
  
  ##############
  ### Render ###
  ##############
  
  def render_html
     page.render_html
  end
  
  
  
end
