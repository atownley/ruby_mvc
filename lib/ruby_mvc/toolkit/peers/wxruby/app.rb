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
# File:     app.rb
# Created:  Wed 23 Nov 2011 11:53:28 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby
      class App < Wx::App
        Toolkit::App.peer_class = self

        def initialize(options, &block)
          super()
          @block = block
          @options = options
          main_loop
        end
    
        def on_init
          if icon = @options[:icon]

# FIXME: the following does what yu expect, but the issue is
# that we need to destroy it when the last application window
# is closed (meaning we also need to track windows for this
# too).  tbicon.remove_icon should cause everything to shut
# down the way we expect.  What a PITA!!!
#
#            if Wx::PLATFORM == "WXMAC"
#              # ensure we have a dock icon set
#              tbicon = Wx::TaskBarIcon.new
#              tbicon.set_icon(WxRuby.load_icon(icon), @options[:title])
#              class << tbicon
#                def create_popup_menu
#                  puts "popup menu"
#                  Wx::Menu.new
#                end
#              end
#            end
          end
          @block.call
        end
      end
    end
  end
end
