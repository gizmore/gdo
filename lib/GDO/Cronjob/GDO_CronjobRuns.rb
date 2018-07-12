#
#
#
class GDO::Cronjob::GDO_CronjobRuns < GDO::Core::GDO

  def fields
    [
      ::GDO::DB::GDT_String.new(:crun_method).ascii.primary,
      ::GDO::Date::GDT_Timestamp.new(:crun_last_run).not_null,
    ]
  end
  
  def next_run(method)
    
  end
  
  def self.should_run?(method)
    return true if method.launch_everytime
    run = table.find_where("crun_method=#{quote(method.class.name)}")
    return true if run.nil?
    nextrun = run.next_run(method)
    if nextrun 
  end
  
  def self.after_run(method)
    blank(
      :crun_method => method.class.name,
      :crun_last_run => DateTime.new.to_s,
    ).replace
  end

end