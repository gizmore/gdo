#
# Basic String class.
# Many GDT inherit this one.
# DB capable.
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::DB::GDT_String < GDO::DB::GDT_DBField

  ###########
  ### GDT ###
  ###########
  def initialize(name=nil)
    super
    @min = nil
    @max = 255
    @pattern = nil
    @encoding = UTF8
    @case_i = true
  end

  def _min; @min; end
  def min(min); @min = min; self; end

  def _max; @max; end
  def max(max); @max = max; self; end

  def _pattern; @pattern; end
  def pattern(pattern); @pattern = pattern; end

  UTF8 ||= 1
  ASCII ||= 2
  BINARY ||= 3
  def _encoding; @encoding; end
  def encoding(encoding); @encoding = encoding; self; end
  def utf8; encoding(UTF8); end
  def ascii; encoding(ASCII); end
  def binary; encoding(BINARY); end

  def case_i(i=true); @case_i = i; self; end
  def case_s(s=true); @case_i = !s; self; end
  
  ##############
  ### Render ###
  ##############
  def render_form; ::GDO::Core::GDT_Template.render_template('DB', 'form/gdt_string.erb', {:field => self}); end

  #############
  ### MySQL ###
  #############
  def column_define
    "VARCHAR(#{@max}) CHARSET #{column_define_charset} COLLATE #{column_define_collate} #{column_define_null}#{column_define_default}"
  end

  def column_define_charset
    case @encoding
    when UTF8; "utf8"
    when ASCII; "ascii"
    when BINARY; "binary"
    end
  end

  def column_define_collate
    case @encoding
    when UTF8; @case_i ? "utf8_general_ci" : "utf8_bin"
    when ASCII; @case_i ? "ascii_general_ci" : "ascii_bin"
    when BINARY; "ascii_bin"
    end
  end

  ################
  ### Validate ###
  ################
  def validate(value)
    return false unless super(value)
    return error(t(:err_str_too_short, @min)) if @min && (@min > value.length)
    return error(t(:err_str_too_long, @max)) if @max && (@max < value.length)
    true
  end

end
