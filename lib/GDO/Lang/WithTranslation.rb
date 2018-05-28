module GDO::Lang::WithTranslation

  def t(key, args)
    Trans.instance.t(key, args)
  end

end