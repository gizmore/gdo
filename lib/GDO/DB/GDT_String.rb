module GDO::DB
  class GDT_String < ::GDO::Core::GDT

    def initialize
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

    UTF8 = 1
    ASCII = 2
    BINARY = 3
    def _encoding; @encoding; end
    def encoding(encoding); @encoding = encoding; self; end
    def utf8; encoding(UTF8); end
    def ascii; encoding(ASCII); end
    def binary; encoding(BINARY); end

    def caseI; @case_i = true; self; end
    def caseS; @case_i = false; self; end

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
    def string_error
      error(t('err_'))
    end

    def validate(value)
      return string_error if (!@min.nil?) && (@min > value.length)
      return string_error if (!@max.nil?) && (@max < value.length)
      super.validate(value)
      self
    end


  end
end