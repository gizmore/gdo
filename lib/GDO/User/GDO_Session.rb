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
        ::GDO::DB::AutoInc.make('sess_id'),
        ::GDO::DB::GDT_Token.make('sess_sid'),
        ::GDO::User::GDT_User.make('sess_user'),
      ]
    end
    
  end
end
