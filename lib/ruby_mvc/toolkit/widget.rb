#--
######################################################################
#
# Copyright 2011 Andrew S. Townley
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
# File:     widget.rb
# Created:  Wed 23 Nov 2011 10:34:52 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
  
    # This class defines the base toolkit widget class.  Each
    # widget has one - and only one - UI peer that is
    # registered automatically when the UI peer is loaded.

    class Widget
      include SignalHandler
      extend SignalHandler::ClassMethods

      class << self
        attr_accessor :peer_class

        # This method is used to manage the API methods
        # available to the toolkit widgets.  Methods listed
        # here will be forwarded to the peer class if they
        # aren't defined by the toolkit widget subclass.

        def api_methods(*args)
          if !@api
            @api = []
            if self.superclass.respond_to? :api_methods
              @api.concat(self.superclass.api_methods)
            end
          end
          @api.concat(args) if args.size > 0
          @api
        end
        alias :api_method :api_methods
      end

      attr_reader :peer
      api_methods :show, :hide

      def initialize(*args, &block)
        if pc = self.class.peer_class
          @peer = pc.new(*args, &block)
          connect_peer_signals
        else
          raise RuntimeError, "no peer class registered for #{self.class}"
        end
      end

      # This method will forward only those registered API
      # methods to the peer class.  Doing it this way ensures
      # that we don't leak APIs from the peers into
      # applications, but that we can still be efficient in
      # how we manage the implementations.
      #
      # FIXME: there may be performance implications...

      def method_missing(method, *args, &block)
        if (self.class.api_methods || []).include? method
          @peer.send(method, *args, &block)
        else
          super
        end
      end

    protected

      # This method is used to ensure that the signals defined
      # for the widget are appropriately connected to the new
      # peer instance when it's created.
      #
      # The normal mechanism is to simply forward the signal
      # to the registered listeners on the toolkit widget.  It
      # is assumed that the peer classes send the appropriate
      # arguments to the signal handlers.

      def connect_peer_signals
        self.class.signals.each do |s, opts|
          puts "connecting signal '#{s}' to #{peer}"
          peer.signal_connect(s) do |*args|
            args[0] = self
            signal_emit(s, *args)
          end
        end
      end
    end
  end
end
