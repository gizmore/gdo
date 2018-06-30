#
# GDO::Core::WithEvents
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.nets
#
# Very simple event library. Supports instance and class subscriptions.
# Has useful debug output on subscriptions and consumptions with source location of subscribers.
# Events can survive a code reload. This is possible via optional unique identifers, specified in subscribe. This would be only required for class subscriptions.
#
# @example
# extend ::GDO::Core::WithEvents # for class subscriptions.
# include ::GDO::Core::WithEvents # for instance subscriptions.
# class Foo; extend WithEvents; subscribe(:gdo_user_activated, 'my-uid-wechall-user-activate') do |user| puts user.inspect; end; end
# publish(:gdo_user_activated, user)
#
module GDO::Core::WithEvents
  
  EVENT_KEY ||= :@@gdo_events # magic class var
  
  @@name ||= 1 # auto identifier
  
  ###########
  ### API ###
  ###########
  def subscribe(event, identifier=nil, &block)
    if identifier.nil?
      identifier = "gdo#{@@name}"
      @@name += 1
    end
    event_subscriptions(event)[identifier] = block
    ::GDO::Core::Log.verbose(display_subscribed(event, block))
  end

  # Trigger an event and call subscribers.
  def publish(event, *event_args)
    ::GDO::Core::Log.debug("GDO::Core::WithEvents.publish(#{event}, #{event_args.inspect})")
    event_subscriptions(event).each do |identifier, subscription|
      ::GDO::Core::Log.verbose(display_publish_consumed(event, subscription))
      begin
        subscription.call(*event_args)
      rescue => e # log and rethrow
        ::GDO::Core::Log.exception(e)
        raise e
      end
    end
  end

  private
  # global subscribers
  def all_subscriptions
    GDO::Core::WithEvents.class_variable_defined?(EVENT_KEY) ?
      GDO::Core::WithEvents.class_variable_get(EVENT_KEY) :
      GDO::Core::WithEvents.class_variable_set(EVENT_KEY, {})
  end
  
  # subscribers for one event
  def event_subscriptions(event)
    all_subscriptions[event] ||= {}
  end

  #############
  ### Debug ###
  #############
  # print subscription event
  def display_subscribed(event, subscription)
    "subscribe(#{event}) by #{subscription_location(subscription)}"
  end

  # print publish consumed event
  def display_publish_consumed(event, subscription)
    "publish(#{event}) consumed by #{subscription_location(subscription)}"
  end
  
  # print sourcecode location
  def subscription_location(subscription)
    sl = subscription.source_location
    file = sl[0].substr_from('/GDO/', sl[0])
    line = sl[1]
    "#{file} #{line}"
  end

end
