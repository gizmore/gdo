#
# Abstract Cronjob Method.
# These are recognized by the GDO::Cronjob::Method::Launcher
#
# You have to override at least one launch method for timing. Else your cronjob will never run.
#
# @version 1.00
# @since 1.00
# @author gizmore@wechall.net
# @license MIT
#
class GDO::Method::Cronjob < GDO::Method::Base
  
  def permission; :admin; end # sane default
  
  #################
  ### Overrides ###
  #################
  def launch_everytime; false end # Just launch every second
  def launch_every; 0; end # Launch every N seconds. Use an int
  def launch_time; nil; end # Launch at a specific time or now if its too late already. Use a string with "HH:II"
  def launch_datetime; nil; end # Launch at a specific datetime. Use a ruby Datetime object here
  
  def execute
    raise ::GDO::Core::Exception.new(t(:err_cronjob_stub_method))
  end
  
end
