#
# AntiCSRF Datatype to plug into GDT_Form.
# Validates a user's CSRF token.
#
# @see https://en.wikipedia.org/wiki/Cross-site_request_forgery
# @see https://de.wikipedia.org/wiki/Cross-Site-Request-Forgery
#
#
# @see GDO::User::GDO_Session 
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Form::GDT_CSRF < GDO::Core::GDT
  
  def initialize
    super
  end
  
  def validate(value)
    true # TODO: Re-Implement from GDO6
  end
  
end
