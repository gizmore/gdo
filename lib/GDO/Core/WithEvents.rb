module GDO::Core::WithEvents

  def self.included(base); base.extend(self); end
  
  EVENT_KEY ||= :@@gdo_events
  
  def all_subscriptions
    GDO::Core::WithEvents.class_variable_defined?(EVENT_KEY) ?
      GDO::Core::WithEvents.class_variable_get(EVENT_KEY) :
      GDO::Core::WithEvents.class_variable_set(EVENT_KEY, {})
  end
  
  def event_subscriptions(event)
    all_subscriptions[event] ||= []
  end

  def subscribe(event, &block)
    # bot.log_debug(display_subscribed(event, block))
    event_subscriptions(event).push(block)
  end

  def publish(event, *event_args)
    event_subscriptions(event).each do |subscription|
      # bot.log_debug(display_publish_consumed(event, subscription))
      begin
        subscription.call(*event_args)
      rescue StandardError => e
        ::GDO::Core::Log.exception(e)
        raise e
      end
    end
  end

  #############
  ### Debug ###
  #############
  def display_subscribed(event, subscription)
    "subscribe(#{event}) by #{subscription_location(subscription)}"
  end

  def display_publish_consumed(event, subscription)
    "publish(#{event}) consumed by #{subscription_location(subscription)}"
  end
  
  def subscription_location(subscription)
    sl = subscription.source_location
    file = sl[0].substr_from('/plugins/')
    line = sl[1]
    "#{file} #{line}"
  end

end