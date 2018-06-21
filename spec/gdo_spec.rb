#
# Show me your specs and i learn how to use your gem :)
# This is more worth than any doc
#
require "byebug"
require "mysql2"
require "gdo"

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
          GDO::DB::GDT_Name.new(:skv_key).primary.not_null,
          GDO::DB::GDT_String.new(:skv_value)
      ]
    end
  end
  
  # Test module
  module Test
    
    class Upgrade1_01
      def upgrade
        ::GDO::Test::Module.instance.save_config_var(:test_setting, 'stubby v1.01')
      end
    end
    
    class Module < ::GDO::Core::GDO_Module
      
      is_module __FILE__
      
      def version; @xv ||= 1.00; end
      def version_up; @xv ||= 1.00; @xv += 0.01; end
      
      def on_load_language; load_language('lang/test'); end
      
      # Module config vars
      def module_config
        [
          ::GDO::DB::GDT_String.new('test_setting').initial('stubby')
        ]
      end
      
      def user_config
        
      end
      
      def user_settings
        
      end
      
      def self.reload
        is_module __FILE__
      end
      
    end
  end


  # GDO6 tests
  RSpec.describe GDO do

    it "has a version number" do
      expect(GDO::VERSION).not_to be nil
    end
    
    it "has a working autoloader" do
      expect(::GDO::Net::GDT_Url).to be_a(::Class)
      expect{::GDO::Net::GDT_NOEXIST}.to raise_error(::GDO::Core::Exception)
    end

    it "names GDT correctly, also automatically" do
      expect(GDO::DB::GDT_String.new._name).to eq("gdo1")
      expect(GDO::DB::GDT_String.new._name).to eq("gdo2")
      expect(GDO::DB::GDT_String.new(:test)._name).to eq("test")
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
      # Basic
      expect(::GDO::Core::GDT_Template._erb("This is a <%=x%>", :x => 'Test')).to eq("This is a Test")
      # Try some form rendering
      form = ::GDO::Form::GDT_Form.new
      form.add_field ::GDO::DB::GDT_String.new
      html = form.render_html
      expect(html.index('container')).to be_truthy
      expect(html.index('<input')).to be_truthy
      expect(html.index('<form')).to be_truthy
    end

    it "can create and drop gdo tables" do
      ::GDO::SPECSimpleKV.table.create_table
      ::GDO::SPECSimpleKV.table.drop_table
      ::GDO::SPECSimpleKV.table.create_table
    end
    
    it "has a working gdo selection cache" do
      row = ::GDO::SPECSimpleKV.blank("skv_key" => 'version', "skv_value" => '1.0.1').insert # insert a row
      expect(::GDO::SPECSimpleKV.table.find('version')).to equal(row) # select from cache uses EQUAL as test; Same instance
      expect(::GDO::SPECSimpleKV.table.find('version').get_var(:skv_value)).to eq('1.0.1') # still same instance
    end
    
    it "can install gdo modules" do
      installer = ::GDO::Core::ModuleInstaller.instance
      installer.install_module ::GDO::Core::Module.instance

      installer.drop_module ::GDO::Core::Module.instance
      installer.drop_module ::GDO::User::Module.instance
      installer.drop_module ::GDO::Test::Module.instance
      
      installer.install_module ::GDO::Core::Module.instance
      installer.install_module ::GDO::User::Module.instance
      installer.install_module ::GDO::Test::Module.instance
      expect(::GDO::Core::GDO_Module.table.select('COUNT(*)').execute.fetch_var).to eq('3') # now 3 modules in db

      installer.install_module ::GDO::Test::Module.instance
      expect(::GDO::Core::GDO_Module.table.select('COUNT(*)').execute.fetch_var).to eq('3') # still 3 modules in db
    end

    
    it "can upgrade gdo modules" do
      ::GDO::Core::Application.reload_gdo
      ::GDO::Test::Module.instance.version_up # hack in test module
      ::GDO::Core::ModuleInstaller.instance.install_module ::GDO::Test::Module.instance # install again
      expect(::GDO::Test::Module.instance.module_version).to eq('1.01')
      expect(::GDO::Test::Module.instance.config_var(:test_setting)).to eq('stubby v1.01')
      expect(::GDO::Core::GDO_Module.table.select('COUNT(*)').execute.fetch_var).to eq('3') # still 3
    end

    it "provides a translation engine" do
      expect(t(:test)).to eq("This is another test.")
      expect(t(:test2, 1, 2)).to eq("This is test 12.")
    end
    
    
    it "can configure module vars" do

      ::GDO::Core::Application.reload_gdo
      expect(::GDO::Test::Module.instance.config_var(:test_setting)).to eq('stubby v1.01')

      # Load the test module
      mod = ::GDO::Test::Module.instance; expect(mod).to be_truthy
      mod.delete_config_var(:test_setting)

      # Load the initial config value
      expect(mod.config_var(:test_setting)).to eq('stubby')
      # Alter the config value
      mod.set_config_var(:test_setting, 'hubby')
      expect(mod.config_var(:test_setting)).to eq('hubby')
      
      # Flush cache
      ::GDO::Core::Application.reload_gdo
      mod2 = ::GDO::Test::Module.instance
      expect(mod != mod2).to be_truthy
      expect(mod2.config_var(:test_setting)).to eq('stubby')
      
      # Save var
      mod2.save_config_var(:test_setting, 'hubby')
      expect(mod2.config_var(:test_setting)).to eq('hubby')

      # Reload
      ::GDO::Core::Application.reload_gdo
      mod2 = ::GDO::Test::Module.instance
      expect(mod2.config_var(:test_setting)).to eq('hubby')
    end
    
    it "can create an admin user" do
      ::GDO::User::GDO_User.blank(
        user_name: "gizmore",
        user_password: ::GDO::Crypto::GDT_PasswordHash.hash('11111111'),
        user_email: ENV['GDO_BOT_MAIL'],
      ).insert
      expect(::GDO::User::GDO_User.table.find_by_name(:gizmore)).to be_truthy
    end

  end
end
