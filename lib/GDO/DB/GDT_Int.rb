module GDO::DB
  class GDT_Int < ::GDO::Core::GDT

    def column_define
      "#{column_define_size}INT #{column_define_unsigned} "
    end

    def column_define_size
      case @bytes
      when 1; return "TINY "
      when 2; return "MEDIUM "
      else; return @bytes > 4 ? "BIG " : ''
      end
    end

    def initialize
      @bytes = 4
      @min = @max = nil
      @unsigned = false
      super
    end

    def _bytes; @bytes; end
    def bytes(bytes); @bytes = bytes; self; end

    def _min; @min; end
    def min(min); @min = min; self; end

    def _max; @max; end
    def max(max); @max = max; self; end

    def _unsigned; @unsigned; end
    def unsigned(unsigned); @unsigned = unsigned; self; end


    def validate(value)

    end


  end
end
