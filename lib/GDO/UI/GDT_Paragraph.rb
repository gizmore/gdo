class GDO::UI::GDT_Paragraph < GDO::UI::GDT_Label
  def render_html; "<p>" + html(_var) + '</p>'; end
end
