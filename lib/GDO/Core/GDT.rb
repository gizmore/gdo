module GDO::Core
  class GDT

    include ::GDO::Core::WithName
    
    def self.allocated; @@allocated; end
    
    def initialize
      @initial = nil
      @var = nil
      @val = nil

      @not_null = false
      @unique = false
      @index = false
      @primary = false

      @error = nil
      
      @@allocated ||= 0; @@allocated += 1
    end

    ##########
    ### DB ###
    ##########
    def identifier; ::GDO::Core::GDO.quoteIdentifier(@name); end
    def column_define; raise ::GDO::Core::Exception.new(t(:err_not_a_db_gdt, self.class.name)); end
    def column_define_null; @not_null ? 'NOT NULL ' : ''; end
    def column_define_default; "DEFAULT #{::GDO::Core::GDO.quote(@initial)} " unless @initial.nil?; end

    ###########
    ### GDT ###
    ###########
    def _gdo; @gdo; end
    def gdo(gdo); @gdo = gdo; self; end

    def _not_null; @not_null; end
    def not_null; @not_null = true; self; end

    def _unique; @unique; end
    def unique; @unique = true; self; end

    def index; @index = true; self; end
    def _index; @index; end

    def primary; @primary = true; self; end
    def _primary; @primary; end

    def _initial; @initial; end
    def initial(initial); @initial = initial.to_s; var(initial); end

    def _var; @var; end
    def var(var); @var = var.to_s; @val = nil; self; end
    def to_var(value); value.to_s; end

    def _value; @val ||= to_value(@var); end
    def value(value); @val = value; @var = to_var(value); self; end
    def to_value(var); var.to_s; end
    
    ################
    ### Validate ###
    ################
    def _error; @error; end
    def error(message); @error = message; false; end
    def error_not_null; error(t('err_not_null')); end
    
    def validate(value)
      return error_not_null if value.nil? && @not_null
      true
    end
    
    ##############
    ### Events ###
    ##############
    def before_create(gdo); end
    def after_create(gdo); end
    def before_update(gdo, query); end
    def after_update(gdo); end
    

  end
end
