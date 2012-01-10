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
          go_back
        end

        def sensitive
          x = @options[:widget].can_go_back?
          property_changed(:sensitive, @sensitive, x)
          @sensitive = x
        end
      end

      class << action(:forward, 
        :label => "Forward", :icon => :stock_forward, :widget => widget) do
          go_forward
        end

        def sensitive
          x = @options[:widget].can_go_forward?
          property_changed(:sensitive, @sensitive, x)
          @sensitive = x
        end
      end

      class << action(:reload,
        :label => "Reload", :icon => :stock_reload, :widget => widget) do
          reload
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

    def go_forward
      reset_actions
      widget.go_forward
      append_actions((location || {})[:actions])
    end

    def go_back
      reset_actions
      widget.go_back
      append_actions((location || {})[:actions])
    end

    def open(uri)
      reset_actions
      widget.open(uri)
    end

    def load_html(*args)
      reset_actions
#      puts "#load_html: " << args.inspect
      widget.load_html(*args)
    end

    def reload
      if location && v = location[:view]
        load(v, location[:uri])
      else
        super
      end
    end

    def append_html(*args, &block)
      widget.append_html(*args, &block)
    end

    def load(view, uri = nil)
      if !view.is_a? WebContentView
        raise ArgumentError, "view must currently be a WebContentView instance"
      end

      # FIXME: need action support in the history management
      # too so that actions are appropriately added/removed
      # during forward/backward navigation requests

      load_html(view.render, uri || view.uri)
      widget.location[:view] = view

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

      # add any content actions
      append_actions(view.actions)
    end

    def add(view)
      if !view.is_a? WebContentView
        raise ArgumentError, "view must currently be a WebContentView instance"
      end

      append_html(view.render)

# FIXME: this should really be done, but we need to be a bit
# more sophisticated in the way we manage it
#      append_actions(view.actions)
    end

  private
    def append_actions(actions)
      return if !actions

      location[:actions] = actions if location
      frame.merge_actions(actions)
    end

    def reset_actions
      if location && (ca = location[:actions])
        frame.unmerge_actions(ca)
      end
    end
  end

end
end
