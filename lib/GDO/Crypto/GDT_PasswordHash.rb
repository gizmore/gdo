require 'bcrypt'
#
# A password that is hashed before saving.
# Uses bcrypt.
# Does not render at all.
#
# @author gizmore@wechall.net
#
class GDO::Crypto::GDT_PasswordHash < GDO::DB::GDT_String
  
  def default_label; t(:password); end
  
  def initialize(name=nil)
    super
    min(59)
    max(60)
    ascii
    case_s
  end
  
  def to_value(var)
    return nil if var.nil? || var.empty?
    self.class.hash(var)
  end
  
  def self.hash(password)
    BCrypt::Password.create(password)
  end
  
  def validate_password(plaintext)
    return false unless old_hash = _var
    return BCrypt::Password.new(old_hash) == plaintext
  end

end
