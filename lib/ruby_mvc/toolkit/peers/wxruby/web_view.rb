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
          if self.respond_to? :evt_html_link_clicked
            evt_html_link_clicked self, :on_link_clicked
            #evt_html_cell_hover self, :on_hover
          end
          @history = BrowserHistory.new
        end

        def location
          @history.current
        end

        def can_go_back?
          @history.has_prev?
        end

        def can_go_forward?
          @history.has_next?
        end

        def go_back
          load_entry @history.prev
        end

        def go_forward
          load_entry @history.next
        end

        def open(uri)
          @history << { :uri => uri }
          load_entry(@history.current)
        end

        def stop_loading
          # apparently, we can't do this
        end

        def reload
          load_entry(@history.current)
        end

        def load_html(html, base_uri = nil)
          # FIXME: this isn't quite right...
          if base_uri
            if base_uri != @history.current[:uri]
              @history << { :uri => base_uri, :content => html }
            else
              @history.current[:content] = html
            end
          else
            @history << { :uri => base_uri, :content => html }
          end
          load_entry(@history.current)
        end

        def append_html(html = "", &block)
          # FIXME: not sure if I want to keep this API as it
          # seems kinda clunky...
          h = html || ""
          h << block.call if block
          @history.current[:content] << h
          append_to_page(h)
        end

        #--
        # wxRuby event handlers
        #++

        def on_link_clicked(link)
          if link.is_a? Wx::HtmlLinkEvent
            # fixup for version 2.0.1 API changes
            link = link.link_info
          end
          signal_emit("navigation-requested", self, link.href, link.target)
        end

      protected
        def load_entry(entry)
          if html = entry[:content]
            set_page(html)
          else
            load_page(entry[:uri])
          end
          signal_emit("load-finished", self, entry[:uri])
        end

      end
    end
  end
end
