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
# File:     html_view.rb
# Created:  Wed 23 Nov 2011 12:43:10 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby
      class WebView < Wx::HtmlWindow
        include Toolkit::SignalHandler
        include Common
        Toolkit::WebView.peer_class = self

        def initialize(options = {}, &block)
          super(WxRuby.parent(options))
          set_background_colour(Wx::WHITE)
        end

        attr_reader :location

        def can_go_back?
          history_can_back
        end

        def can_go_forward?
          history_can_forward
        end

        def go_back
          history_back
        end

        def go_forward
          history_forward
        end

        def open(uri)
          @location = uri
          load_page(uri)
        end

        def stop_loading
          # apparently, we can't do this
        end

        def reload
          open(location)
        end

        def load_html(html, base_uri = nil)
          # FIXME: this isn't quite right...
          set_page(html)
          @location = base_uri
        end

        #--
        # wxRuby event handlers
        #++

        def on_link_clicked(link)
          signal_emit("navigation-requested", self, link.href, link.target)
        end

      end
    end
  end
end
