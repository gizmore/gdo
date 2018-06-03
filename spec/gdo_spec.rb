#
# Show me your specs and i learn how to use your gem :)
# This is more worth than any doc
# @be

#

require "GDO"


# Test classes
module GDO
  
  # Dataset test entity.
  # It's tablename is GDO_SPECSimpleKV
  class SPECSimpleKV < Core::GDO
    def gdo_cached; true; end # activate gdo cache
    def mem_cached; false; end # activate memcached
    # DB Columns
    def fields
      [
          GDO::DB::GDT_Name.make(:skv_key).primary.not_null,
          GDO::DB::GDT_String.make(:skv_value)
      ]
    end
  end
  
  # Test module
  class TestModule < Core::GDO_Module
    
    is_module __FILE__
    
    def on_load_language; load_language('lang/test'); end
    
    # Module config vars
    def module_config
      [
        ::GDO::DB::GDT_String.make('skv_key').initial('stubby')
      ]
    end
    
    def user_config
      
    end
    
    def user_settings
      
    end
    
  end


  # GDO6 tests
  RSpec.describe GDO do

    it "has a version number" do
      expect(GDO::VERSION).not_to be nil
    end

    it "names GDT correctly, also automatically" do
      expect(GDO::DB::GDT_String.make._name).to eq("gdo1")
      expect(GDO::DB::GDT_String.make._name).to eq("gdo2")
      expect(GDO::DB::GDT_String.make('test')._name).to eq("test")
    end

    it "can load modules" do
#      ::GDO::Core::ModuleLoader.instance.load_modules
      ::GDO::Core::ModuleLoader.init #.instance.load_module_vars
      expect(::GDO::Core::Module.instance).to be_truthy
    end

    it "can and cannot connect to the database" do
      expect{::GDO::DB::Connection.new('localhost', 'rubygdo', 'wrong_password', 'rubygdo').get_link}.to raise_error(::GDO::DB::Exception)
      db = ::GDO::DB::Connection.new('localhost', 'rubygdo', 'rubygdo', 'rubygdo')
      expect(db.get_link).to be_truthy
    end

    it "can create gdo in memory" do
      kv = GDO::SPECSimpleKV.blank("skv_key" => 'version', "skv_value" => '1.0.0')
    end

    it "has a working template engine" do
      expect(::GDO::Core::GDT_Template._erb("This is a <%=x%>", :x => 'Test')).to eq("This is a Test")
    end

    it "can create and drop gdo tables" do
      ::GDO::SPECSimpleKV.table.create_table
      ::GDO::SPECSimpleKV.table.drop_table
      ::GDO::SPECSimpleKV.table.create_table
    end
    
    it "has a working gdo selection cache" do
      row = ::GDO::SPECSimpleKV.blank("skv_key" => 'version', "skv_value" => '1.0.1').insert
      expect(::GDO::SPECSimpleKV.table.find('version')).to equal(row)
      expect(::GDO::SPECSimpleKV.table.find('version').get_var(:skv_value)).to eq('1.0.1')
    end
    
    it "can flush all caches" do
      ::GDO::DB::Cache.flush
    end
    
    it "can install gdo modules" do
      ::GDO::Core::Module.instance.install
      
    end
    
    it "provides a translation engine" do
      expect(t(:test)).to eq("This is another test.")
      expect(t(:test2, 1, 2)).to eq("This is test 12.")
    end
    
    
    it "can configure module vars" do
      # Load the test module
      mod = ::GDO::TestModule.instance; expect(mod).to be_truthy
      # Load the initial config value
      expect(mod.config_var(:svk_key)).to eq('stubby')
      # Alter the config value
      mod.set_config_var(:svk_key, 'hubby')
      expect(mod.config_var(:svk_key)).to eq('hubby')
      
      # Flush cache
      ::GDO::DB::Cache.flush
      
      # Reload config var
      expect(mod.config_var(:svk_key)).to eq('hubby')
      
      
    end



  end

end