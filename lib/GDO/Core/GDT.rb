#
# GDT is the base class for all GizmoreDataTypes.
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
# @see GDO::DB::GDT_DBField
#
# @see DOC_GDT.md
#
class GDO::Core::GDT
  
  # Statistics
  def self.allocated; @@allocated; end

  ############
  ### Init ###
  ############
  def initialize(name=nil)
    @initial = nil
    @var = nil
    @val = nil
    
    @name = name == nil ? default_name : name.to_s
    @label = default_label

    @error = nil
    @not_null = false
    
    @@allocated ||= 0; @@allocated += 1
  end
  
  def module_name; self.class.name.split('::')[1]; end

  ###########
  ### GDT ###
  ###########
  def _gdo; @gdo; end
  def gdo(gdo); @gdo = gdo; vars(gdo.get_vars); end
  
  def _name; @name; end
  def name(name); @name = name; self; end
  def default_name; @@name ||= 0; @@name += 1; "gdo#{@@name}"; end

  def _label; @label; end
  def label(label); @label = label; self; end
  def default_label; nil; end

  def _not_null; @not_null; end
  def not_null; @not_null = true; self; end

  ##############
  ### Values ###
  ##############

  def _initial; @initial; end
  def initial(initial); @initial = initial.to_s; var(initial); end

  def _var; @var; end
  def var(var); @var = var.to_s; @val = nil; self; end
  def to_var(value); value.to_s; end
  
  #
  # Setup vars from hash.
  # Multiple fields can be managed by a single gdt.
  # E.g.: GDT_Geoposition (lat+lng)
  #
  def vars(vars)
    return var(vars[@name]) if vars.key?(@name) # Key as String version
    return var(vars[@name.to_sym]) if vars.key?(@name.to_sym) # Key as Symbol version
    self
  end

  def _value; @val ||= to_value(@var); end
  def value(value); @val = value; @var = to_var(value); self; end
  def to_value(var); var.to_s; end
  def hash_values; nil; end
  
  def reset; @var = @initial; @val = nil; self; end
  
  ##############
  ### Render ###
  ##############
  def render; @var; end
  
  # HTML rendering
  def render_html; html(@var); end
  def render_form; render_html; end
  def render_option; render_html; end
  def render_cell; render_html; end
  def render_filter; end
  # Other protocols
  def render_cli; @var; end
  def render_json; { @name => render_cli }; end
  def render_ws; end

  # Render helper
  # @deprecated
  # def render_template(path, args={})
    # args['field'] = self # field is default to self
    # ::GDO::Core::GDT_Template.render_template(module_name, path, args)
  # end

  ################
  ### Validate ###
  ################
  def _error; @error; end
  def error(message); @error = message; false; end
  def error_not_null; error(t(:err_not_null)); end
  def has_error?; @error != nil; end
  def html_error_class; @error == nil ? '' : ' gdo-error'; end
  
  #
  # GDTs validate against values.
  # Call super in your GDT first, to check for not null errors.
  # not_null also means required.
  #
  def validate(value)
    return error_not_null if value.nil? && @not_null
    true
  end
  
  ##############
  ### Events ###
  ##############
  def before_create(gdo, query); end
  def after_create(gdo); end
  def before_update(gdo, query); end
  def after_update(gdo); end

end
