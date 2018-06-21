#
# E-Mail field for forms or display.
#
# @see GDO::Mail::Envelope - to send mails
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net 
#
module GDO::Mail
  class GDT_Email < ::GDO::DB::GDT_String
    
    def default_label; t(:email); end

    def initialize(name=nil)
      super
      @min = 3
      @max = 128
      @pattern = /[^@]+@[^@]+/
    end
    
  end
end
