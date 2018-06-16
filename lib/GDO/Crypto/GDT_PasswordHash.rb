require 'bcrypt'
#
# A password that is hashed before saving.
# Uses bcrypt.
# Does not render at all.
#
# @author gizmore@wechall.net
#
class GDO::Crypto::GDT_PasswordHash < GDO::DB::GDT_String
  
  def self.default_label; t(:password); end
  
  def initialize
    super
    min(59)
    max(60)
    ascii
    case_s
  end
  
  def to_value(var)
    return nil if var.nil? || var.empty?
    BCrypt::Password.create(var)
  end
  
  def self.hash(password)
    BCrypt::Password.create(password)
  end
  
end
