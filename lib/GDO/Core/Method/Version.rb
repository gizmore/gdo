#
#
#
class GDO::Core::Method::Version < GDO::Method::Base
  
  def execute
    success("Ruby v#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}")
  end
  
end
