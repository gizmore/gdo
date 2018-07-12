#
# GDT_Enum inherits GDT_Select.
# It does not allow multiple.
# 
class GDO::DB::GDT_Enum < GDO::Form::GDT_Select
  
  def initialize(name=nil)
    super
    @multiple = false
    @enum_values = []
  end
  
  ##############
  ### Select ###
  ##############
  def multiple(multiple=true); raise ::GDO::Core::Exception.new(t(:err_enum_no_multiple, self.class.name, self._name)); end
  
  ##########
  ### DB ###
  ##########
  def column_define
    enums = @enum_values.map{|enum|::GDO::Core::GDO.quote(enum)}.join(',')
    "ENUM (#{enums}) #{column_define_null} #{column_define_default}"
  end
  
  ############
  ### Enum ###
  ############
  def enums(*values); @enum_values = values.map{|val|val.to_s}; self; end
  def _enums; @enum_values; end
  
end
