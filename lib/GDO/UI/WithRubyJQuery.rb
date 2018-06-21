#
# Adds jQuery like API to Objects.
# Most GDT include this.
#
# @see GDO::Core::GDT
# @see GDO::UI::GDT_Label
#
# @since 1.00
# @version 1.00
# @license MIT
# @author gizmore@wechall.net
#
module GDO::UI::WithRubyJQuery
  
  #######################
  ### HTML attributes ###
  #######################
  def attributes
    @attributes ||= {}
  end

  #
  # Render
  # 
  def html_attributes
    html = ''
    attributes.each{|k,v| html += " #{k}=#{v}" }
    html
  end
  
  #
  # Get/Set attribute
  #
  def attribute(key, value=nil)
    key = key.to_s
    return attributes[key] if value.nil?
    attributes[key] = value
    self
  end
  
  #################
  ### CSS Class ###
  #################
  def css_classes
    attributes['class'] ||= ''
    attribute('class').split(',').select{|klass|klass.length>1}
  end

  def add_class(css_class)
    classes = css_classes
    classes.push(css_class) unless classes.include?(css_class)
    self 
  end
  
  def has_class?(css_class)
    css_classes.index(css_class) != nil
  end
  
  def remove_class(css_class)
    classes = css_classes
    index = classes.index(css_class)
    return self if index.nil?
    classes.delete_at(index)
    attribute('class', classes.join(','))
  end
  
  def toggle_class(css_class)
    if has_class?(css_class)
      remove_class(css_class)
    else
      add_class(css_class)
    end
  end

end
