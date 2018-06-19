#
# Very simple logger.
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Core::Log
  
  ##############
  ### Levels ###
  ##############
  VERBOSE  ||= 5
  DEBUG    ||= 4
  INFO     ||= 3
  WARNING  ||= 2
  ERROR    ||= 1
  CRITICAL ||= 0
  
  @@level ||= WARNING

  ############
  ### Init ###
  ############
  def self.init(path, level=WARNING)
    @@path = "#{File.dirname(path)}/protected/logs"
    @@level = level
    @@user = 'System'
    verbose("GDO::Core::Log::init('#{@@path}', level=#{@@level}")
  end
  
  def self.user(user)
    @@user = user
    verbose("GDO::Core::Log.user(#{user})")
  end

  ####################
  ### Logger calls ###
  ####################
  def self.exception(exception)
    trace = exception.backtrace || []
    trace.shift unless trace.empty?
    critical(exception.message + "\n" + trace.join("\n"))
  end
  def self.critical(message)
    log('criticial', message) if @@level >= CRITICAL
  end
  def self.error(message)
    log('error', message) if @@level >= ERROR
  end
  def self.warning(message)
    log('warning', message) if @@level >= WARNING
  end
  def self.info(message)
    log('info', message) if @@level >= INFO
  end
  def self.debug(message)
    log('debug', message) if @@level >= DEBUG
  end
  def self.verbose(message)
    log('debug', message) if @@level >= VERBOSE
  end
  def self.raw(file, line)
    log(file,line)
  end

  #############
  ### Logic ###
  #############
  def self.log(file, line)
    puts line
  end

end
