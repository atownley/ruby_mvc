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
# File:     views.rb
# Created:  Sat 19 Nov 2011 11:28:08 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Views
    
    class View
      def self.widget_def(targ = nil)
        if targ == nil
          @widget_def
        else
          if (x = targ.widget_def).nil?
            if targ != RubyMVC::Views::View
              self.widget_def(targ.superclass)
            end
          else
            x
          end
        end
      end

      def self.create_widget(klass)
        w = self.widget_def(klass)
        args = w[:args] 
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

      attr_accessor :controller, :widget
      def initialize(*args)
        @widget = View.create_widget(self.class)
        if(options = args.last).is_a? Hash
          self.controller = options[:controller]
        end
      end

      def method_missing(m, *a, &b)
        @widget.send(m, *a, &b)
      end
    end
  end
end

#require 'ruby_mvc/views/table_view'
#require 'ruby_mvc/views/ar_model_editor'
#require 'ruby_mvc/views/ar_type_list'
#require 'ruby_mvc/views/ar_type_editor'
require 'ruby_mvc/views/web_view'
