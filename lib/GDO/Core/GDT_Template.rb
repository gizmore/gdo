module GDO::Core
  class GDT_Template < ::GDO::Core::GDT

    def _module; @module; end
    def module(mod); @module = mod; self; end

    def _file; @file; end
    def file(path); @file = path; self; end

    def _tvars; @tvars; end
    def tvars(tvars); @tvars = tvars; self; end

    def render

    end

    def self.render_template(mod, path, tvars)
      pathes = ::GDO::Core::GDT_Theme.pathes

    end

    def self._erb(template, vars)
      ERB.new(template).result_with_hash(vars)
    end

  end
end