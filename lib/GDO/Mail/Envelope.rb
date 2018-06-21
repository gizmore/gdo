require "mail"
#
# This is a mail message sending helper.
# I chose Envelope as classname because it reads nice.
#
class GDO::Mail::Envelope
  
  def initialize
    @sender = ENV['GDO_BOT_MAIL']||'gdor@gizmore.org'
    @sender_name = ENV['GDO_BOT_NAME']||'RubyGDO Security Bot'
  end
  
  def _sender; @sender; end
  def sender(sender); @sender = sender; self; end
  def _sender_name; @sender_name; end
  def sender_name(sender_name); @sender_name = sender_name; self; end
  
  def _recipient; @recipient; end
  def recipient(recipient); @recipient = recipient; self; end
  def _recipient_name; @recipient_name; end
  def recipient_name(recipient_name); @recipient_name = recipient_name; self; end
  
  def _subject; @subject; end
  def subject(subject); @subject = subject; self; end
  
  def _body; @body; end
  def body(body); @body = body; self; end
  
  def user(user)
    byebug
  end
  
  def deliver!
    deliver or raise ::GDO::Mail::Exception(t(:err_mail_delivery))
  end
  
  def deliver
    
  end
  
end
