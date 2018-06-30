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

  def _default_method; @default_method||ENV['GDO_DEFAULT_METHOD']||'Index'; end
  def default_method(method); @default_method = method; self; end
  
  
  #############
  ### HTTPD ###
  #############
  def self.call(env); instance.call(env); end
  def call(env)
    begin
      # Instanciate request
      request = self.class.new_request(env)
      response = self.class.new_response
      
      # TODO: Handle via middleware?
      return [200, {}, ''] if request.head?
      
      # GET Basic parameters
      mo = request.GET["mo"]||_default_module
      me = request.GET["me"]||_default_method
      
      # Setup GDO method from mo/me and request
      method = gdo_module(mo).gdo_method(me)
      method.request(request)
      method.set_parameters(request.GET)
      method.set_parameters(request.POST) if request.post?
      
      # Execute
      response = method.execute_method

    rescue => ex
      # TODO: own exceptions are 200? nah?
      GDO::Core::Log.exception(ex)
      # Error response
      response = GDO::Method::GDT_Response.make_with(
        GDO::UI::GDT_Error.make_with_exception(ex)
      ).code(500)
    end

    # Render page
    ::GDO::Core::Log.verbose("Rendering page with headers" + response._headers.inspect)
    
    page = GDO::UI::GDT_WebPage.instance.response(response)
    [response._code, response._headers, page.render_html]
  end
    

  # def parse_query_string(string)
    # return {} unless string
    # params = Rack::QueryParser::Params
    # parser = Rack::QueryParser.new(params, 10, 10)
    # parser.parse_query(string)
  # end
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
  
  #################
  ### HTTP API? ###
  #################
  def self.new_request(env={})
    Thread.current[:gdo_request] = nil
    request(env)
  end
  def self.request(env={})
    Thread.current[:gdo_request] ||= ::Rack::Request.new(env)
  end
  def self.new_response
    Thread.current[:gdo_response] = nil
    response
  end
  def self.response
    Thread.current[:gdo_response] ||= ::GDO::Method::GDT_Response.new
  end
  def self.cookie(key)
    self.request.cookies[key]
  end

  def self.set_cookie(key, value, no_js=false, https_only=false, lifetime=0)
    ::GDO::Core::Log.debug("Application.set_cookie(#{key}, #{value}, #{no_js}, #{https_only}, #{lifetime})")
    response = self.response
    cookie = response.header('Set-Cookie')
    cookie ||= "";
    cookie += "#{key}=#{value};"
    cookie += " path=/;"
    cookie += " secure;" if https_only
    cookie += " Max-Age=#{lifetime};" if lifetime > 0
    cookie += " HttpOnly;" if no_js
    cookie += " domain=localhost"
    response.header('Set-Cookie', cookie)
    request.cookies[key] = value
  end
    

end
