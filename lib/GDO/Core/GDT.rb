module GDO::Core
  class GDT

    include ::GDO::Core::WithName

    def column_define; end
    def column_define_null; @not_null ? 'NOT NULL ' : ''; end
    def column_define_default; "DEFAULT #{::GDO::Core::GDO.quote(@initial)} " unless @initial.nil?; end

    def identifier; ::GDO::Core::GDO.quoteIdentifier(name); end

    def initialize
      @initial = nil
      @var = nil
      @val = nil
      @not_null = false
      @unique = false
      @index = false
      @primary = false
      @error = nil
    end

    def _initial
      @initial
    end

    def initial(initial)
      @initial = initial
      var(initial)
    end


    def _var; @var; end

    def to_var(value)
      value.to_s
    end

    # @return self
    def var(var)
      @var = var
      @val = to_value(var)
      self
    end


    def _value; @value; end
    def to_value(var)
      var
    end


    def value(value)
      @val = value
      @var = to_var(value)
      self
    end

    def not_null; @not_null = true; self; end

    def _unique; @unique; end
    def unique; @unique = true; self; end

    def _error; @error; end
    def error(message)
      @error = message
      false
    end

    def index; @index = true; self; end
    def _index; @index; end

    def primary; @primary = true; self; end
    def _primary; @primary; end


  end
end
