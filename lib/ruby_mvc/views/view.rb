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
# File:     view.rb
# Created:  Sat 19 Nov 2011 11:28:08 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Views
   
    class View < RubyMVC::Toolkit::AbstractWidget
      attr_reader :actions
      attr_accessor :controller

      def initialize(options = {})
        @actions = ActionGroup.new
        @options = options
        self.controller = options[:controller]
        (options[:actions] || []).each { |a| @actions << a }
      end

    protected
      def action(key, options = {}, &block)
        a = Action.new(key, options, &block)
        @actions << a
        a
      end
    end

    class PeerView < View
      def self.widget_def(targ = nil)
        if targ == nil
          @widget_def
        else
          if (x = targ.widget_def).nil?
            if targ != RubyMVC::Views::PeerView
              self.widget_def(targ.superclass)
            end
          else
            x
          end
        end
      end

      def self.create_widget(klass, options = {})
        w = self.widget_def(klass)
        args = (w[:args].clone << options)
        block = w[:block]
        args[0].new(*args[1..-1], &block)
      end

      class << self
        # This method is used to define the primary widget
        # class through which this view may be added to other
        # widgets.

        def widget(*args, &block)
          puts "Set widget for #{self}: #{args.inspect}"
          @widget_def = { :args => args, :block => block }
        end
      end

      def peer
        @widget.peer
      end

      attr_accessor :widget
      def initialize(options = {})
        super
        @widget = PeerView.create_widget(self.class, options)
      end

      # This method is required to ensure that concrete views
      # appropriately manage signal registration

      def signal_connect(signal, &b)
        puts "Widget class: #{@widget.class}"
        if @widget.class.valid_signal? signal
          @widget.signal_connect(signal, &b)
        else
         puts "super"
          super
        end
      end

      def signal_disconnect(signal, &b)
        if @widget.class.valid_signal? signal
          @widget.signal_connect(signal, &b)
        else
          super
        end
      end

      def method_missing(m, *a, &b)
        @widget.send(m, *a, &b)
      end
    end
  end
end
