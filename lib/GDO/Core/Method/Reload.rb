class GDO::Core::Method::Reload < GDO::Method::Base
  
  def permission; 'admin'; end
  
  def execute
    ::GDO::Core::Application.reload_gdo
    success(t(:msg_application_reloaded))
  end

end
