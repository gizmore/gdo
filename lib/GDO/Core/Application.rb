module GDO::Core
  class Application

    def self.init
      
    end


    def initialize
      
    end
    
    def self.call(env)
    [200, {}, 'Hello World'+env.inspect]
    end


  end
end
