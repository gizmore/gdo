#
# Abstract DB Field
#
class GDO::DB::GDT_DBField < GDO::Core::GDT
  
  def initialize(name=nil)
    super
    @unique = false
    @index = false
    @primary = false
  end
  
  def identifier; ::GDO::Core::GDO.quoteIdentifier(@name); end

  def column_define; raise ::GDO::Core::Exception.new(t(:err_not_a_db_gdt, self.class.name)); end
  def column_define_null; @not_null ? 'NOT NULL ' : ''; end
  def column_define_default; "DEFAULT #{::GDO::Core::GDO.quote(@initial)} " unless @initial.nil?; end

  def _unique; @unique; end
  def unique; @unique = true; self; end

  def index; @index = true; self; end
  def _index; @index; end

  def primary; @primary = true; self; end
  def _primary; @primary; end

end
