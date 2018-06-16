module GDO::UI
  class GDT_Label < GDO::Core::GDT
    
    def _text; @var; end
    def text(text); @var = text; self; end

  end
end
