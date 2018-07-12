module GDO::User
  #
  # Username definition.
  # Has to start with a letter, then also digits, dash, underscore.
  # @since 1.00
  # @author gizmore@wechall.net
  # @see ::GDO::Core::DB::GDT_Name
  #
  class GDT_Username < ::GDO::DB::GDT_String

    def initialize(name=nil)
      super
      @min = 2; @max = 32
      @pattern = "/[a-z][-a-z_0-9]{1,31}/i"
    end

  end
end
