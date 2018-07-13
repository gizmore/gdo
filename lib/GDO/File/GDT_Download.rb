#
# Use to respond with binary files
#
class GDO::File::GDT_Download < GDO::Core::GDT
  
  def initialize(name=nil)
    super
    
  end
  
  def _path; @path; end
  def path(path); @path = path; self; end
  
end