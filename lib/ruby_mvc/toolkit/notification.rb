#--
######################################################################
#
# Copyright 2008, Andrew S. Townley
#
# Permission to use, copy, modify, and disribute this software for
# any purpose with or without fee is hereby granted, provided that
# the above copyright notices and this permission notice appear in
# all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHORS DISCLAIM ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS.  IN NO EVENT SHALL THE
# AUTHORS BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
# File:     notification.rb
# Author:   Andrew S. Townley
# Created:  Sat Nov  1 14:27:10 GMT 2008
# Borrowed: Wed 23 Nov 2011 22:29:22 GMT
#
######################################################################
#++

module RubyMVC
module Toolkit

  # This class allows obsevers to register a single block
  # rather than implementing public observer methods (which
  # can get messy and unnecessarily pollute the public API
  # of the class)
  #
  # Each registered block will be called with the following
  # arguments:
  #
  # 1) The notification name (or the method name to be called)
  # 2) The sender of the notification
  # 3) The notification parameters.

  class ObserverReference
    attr_reader :observer

    def initialize(observer, &block)
      @observer = observer
      @block = block
    end

    def method_missing(method, *args, &block)
      if @observer.respond_to? method
        @observer.send(method, *args, &block)
      elsif !@block.nil?
        @block.call(method, *args)
      else
        super
      end
    end
  end

  class ObserverList
    def initialize
      @observers = {}
    end

    def <<(val)
      if !val.is_a? ObserverReference
        raise ArgumentError, "can only have observer references in the list!"
      end

      @observers[val.observer] = val if !@observers.include? val.observer
    end

    def delete(val)
      @observers.delete(val)
    end

    def each(&block)
      @observers.each_value(&block)
    end
  end

  # This class is used to relay notifications from one sender
  # to another sender's registered listeners.

  class NotificationRelay
    def initialize(sender, listeners)
      @listeners = listeners
      @sender = sender
    end

    def method_missing(method, *args, &block)
      args[0] = @sender
      @listeners.each { |l| l.send(method, *args, &block) }
    end
  end

  module ViewChangeNotifier
    def register_view_change_observer(observer, &block)
      observers = (@view_change_observers ||= ObserverList.new)
      observers << ObserverReference.new(observer, &block)
    end

    def unregister_view_change_observer(observer)
      observers = (@view_change_observers ||= ObserverList.new)
      observers.delete(observer)
    end

  protected
    def fire_view_changed
      observers = (@view_change_observers ||= [])
      observers.each { |o| o.view_changed(self) }
    end
  end

  module ChangeNotifier
    def register_change_observer(observer, &block)
      observers = (@change_observers ||= ObserverList.new)
      observers << ObserverReference.new(observer, &block)
    end

    def unregister_change_observer(observer)
      observers = (@change_observers ||= [])
      observers.delete(observer)
    end

    def squelch=(val)
      @notification_squelch = val
    end

  protected
    def fire_changed
      return if @notification_squelch
      observers = (@change_observers ||= [])
      observers.each { |o| o.changed(self) }
    end
  end

  module PropertyChangeNotifier
    def register_property_change_observer(observer, &block)
      observers = (@property_change_observers ||= [])
      observers << ObserverReference.new(observer, &block)
    end

    def unregister_property_change_observer(observer)
      observers = (@property_change_observers ||= [])
      observers.delete(observer)
    end

    def squelch=(val)
      @notification_squelch = val
    end

  protected
    def fire_property_changed(property, old_val, new_val)
      return if @notification_squelch
      observers = (@property_change_observers ||= [])
      observers.each { |o| o.property_changed(self, property, old_val, new_val) }
    end
  end

  module SignalHandler
    module ClassMethods
      def signals
        @signals ||= {}
      end

      def signal(signal, options = { :vetoable => false })
        signals[signal] = options
      end

      def valid_signal?(signal)
        if !signals.has_key? signal
          raise ArgumentError, "class #{self} does not support signal '#{signal}'"
        end
      end
    end

    def signal_connect(signal, &block)
      self.class.valid_signal? signal if self.class.respond_to? :signals
      signals = (@signals ||= {})
      signals[signal] = block
    end

    def signal_disconnect(signal)
      self.class.valid_signal? signal if self.class.respond_to? :signals
      signals = (@signals ||= {})
      signals.delete(signal)
    end

    def signal_emit(signal, *args)
      self.class.valid_signal? signal if self.class.respond_to? :signals
      signals = (@signals ||= {})
      if signals.key? signal
        proc = signals[signal]
        proc.call(*args) if !proc.nil?
      end
    end
  end   
end
end
