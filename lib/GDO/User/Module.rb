#
module GDO::User
  #
  # The user module installs the system user and offers user management functionality.
  # It also provides session handling.
  #
  # @author gizmore@wechall.net
  # @license MIT
  # @version 1.00
  # @since 1.00
  #
  # @see ::GDO::Core::Module
  # @see ::GDO::Core::GDO_Module
  #
  class Module < GDO::Core::GDO_Module

    is_module __FILE__
    
    def tables
      [
        ::GDO::User::GDO_User,
        ::GDO::User::GDO_Session,
      ]
    end
    
    #
    # Install the system user after install
    #
    def after_install
      users = ::GDO::User::GDO_User
      system = users.table.find(1)
      return unless system.nil?
      system = users.blank(
        user_id: 1,
        user_name: "System",
        user_email: ENV['GDO_BOT_MAIL'] || 'gdo@localhost',
        user_type: ::GDO::User::GDT_UserType::BOT,
      ).replace
    end
    

  end
end
