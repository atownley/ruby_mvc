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
# File:     browser_view.rb
# Created:  Mon  2 Jan 2012 22:44:26 CET
#
#####################################################################
#++ 

module RubyMVC
module Views

  # This class is slightly different at the moment as it
  # really should have a HypermediaContentModel instance that
  # feeds it vs. being explicitly driven by the client.  This
  # should be addressed better in a future version.

  class BrowserView < PeerView
    widget Toolkit::WebView

    def initialize(options = {}, &block)
      super

      class << action(:back,
        :label => "Back", :icon => :stock_back, :widget => widget) do
          widget.go_back
        end

        def sensitive
          x = @options[:widget].can_go_back?
          property_changed(:sensitive, @sensitive, x)
          @sensitive = x
        end
      end

      class << action(:forward, 
        :label => "Forward", :icon => :stock_forward, :widget => widget) do
          widget.go_forward
        end

        def sensitive
          x = @options[:widget].can_go_forward?
          property_changed(:sensitive, @sensitive, x)
          @sensitive = x
        end
      end

      class << action(:reload,
        :label => "Reload", :icon => :stock_reload, :widget => widget) do
          widget.reload
        end

        def sensitive
          w = @options[:widget]
          x = (!w.location.nil? && "" != w.location)
          property_changed(:sensitive, @sensitive, x)
          @sensitive = x
        end
      end

      widget.signal_connect("load-finished") do
#        puts "load-finished #{widget.location}"
        # FIXME: this is a hack, but it's the only way for now
        @actions.each { |a| a.selection(self, nil, nil); a.sensitive }
#        puts "back? #{widget.can_go_back?}"
#        puts "forward? #{widget.can_go_forward?}"
      end

      widget.signal_connect("navigation-requested") do |s, h, t|
        puts "BrowserView#navigation-requested: #{h}"
        if (c = self.controller)
          puts "forwarding to controller: #{c}"
          c.link_activated(s, h)
        end
      end
    end

    def open(uri)
      widget.open(uri)
    end

    def load_html(*args)
      widget.load_html(*args)
    end

    def append_html(*args, &block)
      widget.append_html(*args, &block)
    end

    def load(view)
      if !view.is_a? WebContentView
        raise ArgumentError, "view must currently be a WebContentView instance"
      end

      load_html(view.render, view.uri)

      # If our view provides a different controller, then we
      # need to defer link handling to that controller instead
      # of ours (which probably wasn't defined in the first
      # place)

      if (vc = view.controller) && vc != self.controller
        puts "assigned new controller from WebContentView: #{vc}"
        self.controller = vc
      else
        puts "no controller defined for #{view}"
      end
    end

    def add(view)
      if !view.is_a? WebContentView
        raise ArgumentError, "view must currently be a WebContentView instance"
      end

      append_html(view.render)
    end
  end

end
end
