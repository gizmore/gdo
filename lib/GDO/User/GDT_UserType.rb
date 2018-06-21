#
module GDO::User
  #
  # A UserType is a simple enum of 4 types:
  #
  # 1) ghost (not persisted)
  # 2) bot (banned)
  # 3) guest (persisted)
  # 4) member (with login name persisted)
  #
  # @since 1.00
  # @version 1.00
  # @author gizmore@wechall.net
  #
  # @see ::GDO::DB::GDT_Enum
  # @see ::GDO::User::GDO_User
  #
  class GDT_UserType < ::GDO::DB::GDT_Enum
    
    GHOST  ||= 'ghost'
    BOT    ||= 'bot'
    GUEST  ||= 'guest'
    MEMBER ||= 'member'
    
    def initialize(name=nil)
      super
      enum_values(GHOST, BOT, GUEST, MEMBER)
    end

  end
end
