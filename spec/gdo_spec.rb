require "GDO"

module GDO
  
  # Dataset test entity.
  # It's tablename is GDO_SPECSimpleKV
  class SPECSimpleKV < Core::GDO
    def fields
      [
          GDO::DB::GDT_Name.make(:skv_key).primary.not_null,
          GDO::DB::GDT_String.make(:skv_value)
      ]
    end
  end


  # GDO6 tests
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
      expect(::GDO::SPECSimpleKV.table.find('version')).get_var(:svk_value).to eq('1.0.1')
    end



  end

end