#
module GDO::User
  #
  # Use GDT_Marshall to persist a ruby object in the db.
  #
  class GDO_Session < ::GDO::Core::GDO
    
    ###########
    ### GDO ###
    ###########
    def engine; MYISAM; end # MyISAM allows faster writes than InnoDB?

    def fields
      [
        ::GDO::DB::GDT_AutoInc.new('sess_id'),
        ::GDO::DB::GDT_Token.new('sess_sid'),
        ::GDO::User::GDT_User.new('sess_user'),
      ]
    end
    
  end
end
