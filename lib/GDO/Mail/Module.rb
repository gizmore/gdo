#
# Manages Mail settings.
# Default to ENV.
#
class GDO::Mail::Module < GDO::Core::GDO_Module
  ##############
  ### Config ###
  ##############
  def module_config
    [
      # Mailer name settings
      ::GDO::Mail::GDT_Email.new(:bot_mail_address).not_null.initial(ENV['GDO_BOT_MAIL']||'rubygdo@gizmore.org'),
      ::GDO::DB::GDT_String.new(:bot_mail_sender).initial(ENV['GDO_BOT_NAME']||'rubyGDO E-Mail Bot'),
    ]
  end
  def bot_mail; config_var(:bot_mail_address); end
  def bot_name; config_var(:bot_mail_sender); end
  
end