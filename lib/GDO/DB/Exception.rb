#
# Exception with query as error detail parameter.
#
# @license MIT
# @author gizmore@wechall.net
#
class GDO::DB::Exception < GDO::Core::Exception
  
  def query(query); @query = query; self; end
  
  def to_s
    "#{super.to_s} IN\n#{@query}" 
  end
  
end
