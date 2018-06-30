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
  def initialize(name=nil)
    super
    @code = 200
  end
  
  def _code; @code; end 
  def code(code); @code = code; self; end
  
  def _exception; _fields[0]._exception rescue nil; end
  
end
