#
# Show me your specs and i learn how to use your gem :)
# This is more worth than any doc
#
require 'rubygems'
require 'bundler'
Bundler.require(:default)

require "byebug"
require "mysql2"

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
  module Test
    
    class Upgrade1_01
      def upgrade
        byebug
        ::GDO::Test::TestModule.instance.save_var('skv_key', '1.01')
      end
    end
    
    class TestModule < ::GDO::Core::GDO_Module
      
      is_module __FILE__
      
      def version; @xv ||= 1.00; end
      def version_up; @xv ||= 1.00; @xv += 0.01; end
      
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

    it "can and cannot connect to the database" do
      expect{::GDO::DB::Connection.new('localhost', 'rubygdo', 'wrong_password', 'rubygdo').get_link}.to raise_error(::GDO::DB::Exception)
      db = ::GDO::DB::Connection.new('localhost', 'rubygdo', 'rubygdo', 'rubygdo')
      expect(db.get_link).to be_truthy
    end

    # Actually a db load fails and this sucks as it is rescue nil
    it "can load modules" do
      ::GDO::Core::ModuleLoader.init
      expect(::GDO::Core::Module.instance).to be_truthy
      expect(::GDO::Core::Module.instance).to be_a(::GDO::Core::Module)
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
    
    # This test is my full pride!
    it "has a working gdo selection cache" do
      row = ::GDO::SPECSimpleKV.blank("skv_key" => 'version', "skv_value" => '1.0.1').insert # insert a row
      expect(::GDO::SPECSimpleKV.table.find('version')).to equal(row) # select from cache uses EQUAL as test; Same instance
      expect(::GDO::SPECSimpleKV.table.find('version').get_var(:skv_value)).to eq('1.0.1') # still same instance
    end
    
    it "can flush all caches" do
      ::GDO::DB::Cache.flush # TODO: more cache tests
    end
    
    it "can install gdo modules" do
      installer = ::GDO::Core::ModuleInstaller.instance
      
      # ::GDO::Core::GDO_Module.table.truncate_table
      
      installer.install_module ::GDO::Core::Module.instance
      installer.install_module ::GDO::User::Module.instance
      installer.install_module ::GDO::Test::TestModule.instance
      expect(::GDO::Core::GDO_Module.table.select('COUNT(*)').execute.fetch_var).to eq('3') # now 3 modules in db

      installer.install_module ::GDO::Test::TestModule.instance
      expect(::GDO::Core::GDO_Module.table.select('COUNT(*)').execute.fetch_var).to eq('3') # still 3 modules in db
    end

    
    it "can upgrade gdo modules" do
      ::GDO::Test::TestModule.instance.version_up # hack in test module
      ::GDO::Core::ModuleInstaller.instance.install_module ::GDO::Test::TestModule.instance # install again
      expect(::GDO::Test::TestModule.instance.module_version).to eq('1.01')
      expect(::GDO::Core::GDO_Module.table.select('COUNT(*)').execute.fetch_var).to eq('3') # still 3
    end

    it "provides a translation engine" do
      expect(t(:test)).to eq("This is another test.")
      expect(t(:test2, 1, 2)).to eq("This is test 12.")
    end
    
    
    it "can configure module vars" do
      # Load the test module
      mod = ::GDO::Test::TestModule.instance; expect(mod).to be_truthy
      # Load the initial config value
      expect(mod.config_var(:skv_key)).to eq('stubby')
      # Alter the config value
      mod.set_config_var(:skv_key, 'hubby')
      expect(mod.config_var(:skv_key)).to eq('hubby')
      
      # Flush cache
      ::GDO::DB::Cache.flush
      
      # Reload config var
      expect(mod.config_var(:skv_key)).to eq('hubby')
      
      
    end



  end

end
