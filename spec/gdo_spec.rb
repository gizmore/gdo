require "GDO"

module GDO
  class SPECSimpleKV < Core::GDO
    def fields
      [
          GDO::DB::GDT_Name.make(:skv_key).ascii.primary,
          GDO::DB::GDT_String.make(:skv_value)
      ]
    end
  end


  RSpec.describe GDO do

    ::GDO::Core::ModuleLoader.instance.load_module_vars

    it "has a version number" do
      expect(GDO::VERSION).not_to be nil
    end

    it "names GDT correctly, also automatically" do
      expect(GDO::DB::GDT_String.make.name).to eq("gdo1")
      expect(GDO::DB::GDT_String.make.name).to eq("gdo2")
      expect(GDO::DB::GDT_String.make('test').name).to eq("test")
    end

    it "can load modules" do
      expect(::GDO::Core::Module.instance).to be_truthy
    end

    it "can connect to the database" do
      db = ::GDO::DB::Connection.new('localhost', 'rubygdo', 'rubygdo', 'rubygdo')
     # expect(db.get_link).to be_truthy
    end

    it "can create gdo in memory" do
      kv = GDO::SPECSimpleKV.blank(:svk_key => 'version', :svk_value => '1.0.0')
    end

    it "has a working template engine" do
      expect(::GDO::Core::GDT_Template._erb("This is a <%=x%>", :x => 'Test')).to eq("This is a Test")
    end

    it "can create gdo tables and gdo is basically working" do
      ::GDO::SPECSimpleKV.table.create_table
      row = ::GDO::SPECSimpleKV.blank(:svk_key => 'version', :svk_value => '1.0.1').insert
      expect(::GDO::SPECSimpleKV.table.find('version')).to equal(row)
      expect(::GDO::SPECSimpleKV.table.find('version')).var('svk_value').to eq('1.0.1')
    end



  end

end