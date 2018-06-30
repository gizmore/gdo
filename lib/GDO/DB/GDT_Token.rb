require 'securerandom'
#
# Overwrites initial value with a random token.
#
# @version 1.00
# @since 1.00
# @author gizmore@wechall.net
# @license MIT
#
class GDO::DB::GDT_Token < GDO::DB::GDT_String

  TOKEN_LENGTH ||= 16

  def initialize(name=nil)
    super
    @min = @max = TOKEN_LENGTH
    @encoding = ASCII
    @case_i = false
    @initial = self.class.generate
  end
  
  def self.generate
    ::SecureRandom.hex(TOKEN_LENGTH/2)
  end

end
