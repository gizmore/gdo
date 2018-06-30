class GDO::Install::Method::SystemCheck < GDO::Method::Page
  
  def page_template(gdt_template)
    gdt_template.tvar('ruby_version', 1)
  end

  
end
