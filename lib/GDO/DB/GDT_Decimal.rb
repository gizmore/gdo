module GDO::DB
  class GDT_Decimal < GDT_Int
    
    def column_define
      "DECIMAL(#{column_define_digits}) #{column_define_unsigned} #{column_define_null} #{column_define_default}"
    end
    
    def column_define_digits
      before = @digits_before + @digits_after
      "#{before},#{@digits_after}"
    end
    
    def initialize(name=nil)
      super
      @digits_before = @digits_after = nil
    end
    
    def digits(before, after)
      @digits_before = before
      @digits_after = after
      step = after < 1 ? 1 : (("0" * (after - 1)) + "1").to_f # e.g: Stepping is 0.01 for 2 digits after 
      step(step)
    end
    
    def to_var(value)
      value.round(@digits_after).to_s
    end
    
    def to_value(var)
      var.to_f
    end

  end
end
