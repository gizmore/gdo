module GDO::DB
  class GDT_Int < ::GDO::Core::GDT

    ##########
    ### DB ###
    ##########
    def column_define
      "#{column_define_size}INT #{column_define_unsigned}#{column_define_null}#{column_define_default}"
    end

    def column_define_size
      case @bytes
      when 1; return "TINY "
      when 2; return "MEDIUM "
      else; return @bytes > 4 ? "BIG " : ''
      end
    end
    
    def column_define_unsigned
      @unsigned ? "UNSIGNED " : ""
    end

    ###########
    ### GDT ###
    ###########
    def initialize
      super
      @bytes = 4
      @min = @max = nil
      @unsigned = false
      @step = 1
    end

    def _bytes; @bytes; end
    def bytes(bytes); @bytes = bytes; self; end

    def _min; @min; end
    def min(min); @min = min; self; end

    def _max; @max; end
    def max(max); @max = max; self; end

    def _unsigned; @unsigned; end
    def unsigned(unsigned=true); @unsigned = unsigned; self; end
    
    def _step; @step; end
    def step(step); @step = step; self; end
    
    #############
    ### Value ###
    #############
    def to_value(var)
      var.to_i
    end

    ################
    ### Validate ###
    ################
    def validate(value)
      return false unless super(value)
      return range_error if (@min != nil) && value < @min
      return range_error if (@max != nil) && value > @max
      true
    end
    
    def range_error
      return error(t(:err_number_too_small, @min)) if max.nil?
      return error(t(:err_number_too_large, @max)) if min.nil?
      return error(t(:err_number_not_between, @min, @max))
    end

  end
end
