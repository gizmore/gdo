module GDO::Lang
  class Trans

    def self.instance; @@instance; end


    def add_path(path)
      @pathes.push(path)
      @translations = {}
    end

    def initialize
      @@instance = self
      @pathes = []
      @translations = {}
    end

    def reload
      @translations = {}
      @pathes.each do |path|

      end

    end

    def t(key, *args)

    end

  end
end

