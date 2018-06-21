#
#
# Global application helper?
#
#
require "rack"
require "rack/utils"
require "rack/query_parser"

class GDO::Core::Application
  
  include GDO::Core::WithEvents
  include GDO::Core::WithInstance
  
  def self.init
    instance
  end

  def initialize
  end
  
  def _default_module; @default_module||ENV['GDO_DEFAULT_MODULE']||'Core'; end
  def default_module(mod); @default_module = mod; self; end
  
  
  #############
  ### HTTPD ###
  #############
  def self.call(env); instance.call(env); end
  def call(env)
    begin

      puts env.inspect
      return [200, {}, ''] if env['REQUEST_METHOD'] == 'HEAD'

      parameters = parse_query_string(env['QUERY_STRING'])
      puts parameters.inspect

      mo = parameters["mo"]||_default_module
      me = parameters["me"]||'Index'
      method = gdo_module(mo).gdo_method(me)

      method.set_parameters(parameters)
      response = method.execute_method

      [200, {}, response.render]

    rescue => ex
      GDO::Core::Log.exception(ex)
      response = GDO::Method::GDT_Response.make_with(
        GDO::UI::GDT_Error.make_with_exception(ex)
      )
      page = GDO::UI::GDT_WebPage.instance
      page.response(response)
      [response._code, {}, page.render]
    end
  end
    

  def parse_query_string(string)
    return {} unless string
    params = Rack::QueryParser::Params
    parser = Rack::QueryParser.new(params, 10, 10)
    parser.parse_query(string)
  end
  #
  # Called by passenger/rack
  #
  
  #############
  ### Cache ###
  #############
  def self.clear_cache
    ::GDO::Core::Log.info("GDO::Core::Application.clear_cache()")
    publish(:gdo_cache_flush)
  end

  ##############
  ### Reload ###
  ##############
  #
  # Flush every cache and reload all classes code at runtime.
  #
  def self.reload_gdo
    # Clear
    clear_cache

    # Clear events. they will be rehooked
    ::GDO::Core::WithEvents.class_variable_set(::GDO::Core::WithEvents::EVENT_KEY, {})

    # Reload code
    ::GDO::Core::Util.each_constant(::GDO) do |const|
      const.reload
    end
    # Reload modules
    ::GDO::Core::ModuleLoader.init
  end

end
