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
# File:     signal_handler.rb
# Author:   Andrew S. Townley
# Created:  Sat Nov  1 14:27:10 GMT 2008
# Borrowed: Wed 23 Nov 2011 22:29:22 GMT
#
######################################################################
#++

module RubyMVC
module Toolkit

  # This module provides an implementation of signal handlers
  # originally modelled on the GTK+ 2.x mechanisms.  While it
  # is similar to GTK+, it may not behave in exactly the same
  # way.
  #
  # This module also defines some useful class methods to
  # expand the meta-programming of Ruby objects to support
  # signal handling.  To use these methods, you follow the
  # following idiom in the derived class:
  #
  #   class SignalSource
  #     incude RubyMVC::Toolkit::SignalHandler
  #     extend RubyMVC::Toolkit::SignalHandler::ClassMethods
  #     ...
  #   end
  #
  # Once the class has been defined as per above, valid
  # signals for the signal source may be defined using the
  # class method #signal as follows:
  #
  #   class SignalSource
  #     ...
  #
  #     signal "sig1", :description => "A test signal", 
  #     signal "sig2", :description => "A vetoable signal", :vetoable => true
  #     ...
  #   end
  #
  # To register for signal notification, use the
  # #signal_connect method of the signal source instance as
  # follows:
  #
  #   src = SignalSource.new
  #   src.signal_connect "sig1" do |sender|
  #     ...
  #   end
  #
  # Internally to the signal source instance, the signal can
  # be triggered using the #signal_emit method as follows
  #
  #   class SignalSource
  #     def send_sig1
  #       ...
  #       signal_emit("sig1", self)
  #       ...
  #     end
  #   end
  #
  # Planned Areas of Improvement
  # ============================
  #
  # Currently, there's not a really good way to document the
  # signals so that they're clear.  I'm not sure how these are
  # represented in rdoc, but there should be a method/way to
  # specify the arguments in order and what they should be so
  # that they live with the signal definition within the class
  # itself so things are self-documenting.
  
  module SignalHandler
    module ClassMethods
      def signals
        @signals ||= {}
      end

      def signal(signal, options = { :vetoable => false })
        signals[signal] = options
      end

      def valid_signal?(signal)
        if !signals.has_key?(signal) && (self.superclass.respond_to?(:valid_signal?) && !self.superclass.valid_signal?(signal))
          raise ArgumentError, "class #{self} does not support signal '#{signal}'"
        end
        true
      end
    end

    def signal_connect(signal, &block)
      self.class.valid_signal? signal if self.class.respond_to? :signals
      signals = (@signals ||= {})
      sigs = (signals[signal] ||= [])
      if !sigs.include? block
        sigs << block
      end
    end

    def signal_disconnect(signal, &block)
      self.class.valid_signal? signal if self.class.respond_to? :signals
      signals = (@signals ||= {})
      sigs = (signals[signal] ||= [])
      sigs.delete(block)
    end

    def signal_emit(signal, *args)
      self.class.valid_signal? signal if self.class.respond_to? :signals
      signals = (@signals ||= {})
      (signals[signal] ||= []).each do |proc|
        proc.call(*args) if !proc.nil?
      end
    end
  end

end
end
