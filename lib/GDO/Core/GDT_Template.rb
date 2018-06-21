#
# Template engine embedded in a GDT.
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Core::GDT_Template < GDO::Core::GDT

  ###########
  ### GDT ###
  ###########
  def _file; @file; end
  def file(path); @file = path; self; end

  def _tvars; @tvars; end
  def tvars(tvars); @tvars = tvars; self; end

  def render
    self.class.render_template(@file, @tvars)
  end

  ################
  ### Renderer ###
  ################
  def self.render_template(path, vars)
    pathes = ::GDO::Core::GDT_Theme.pathes
    byebug

  end

  def self._erb(template, vars)
    ERB.new(template).result_with_hash(vars)
  end

end
