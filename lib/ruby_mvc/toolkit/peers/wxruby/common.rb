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
# File:     common.rb
# Created:  Wed 23 Nov 2011 10:46:35 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby

      # This method is a hack to deal with the parenting
      # issues around the way wxWindows requires a parent for
      # all child windows, and other toolkits don't.

      def self.default_parent
        @@parent ||= 1
        if 1 == @@parent
          @@parent = Wx::Frame.new(nil, :size => [40, 40])
          class << @@parent 
            def should_prevent_app_exit
              false
            end
          end
        end
        @@parent
      end

      # This method is used to retrieve the parent window from
      # the options, or it will use the default parent window.

      def self.parent(options = {})
        if (p = options[:parent]) && (p = p.peer)
          p
        else
          default_parent
        end
      end
          
      # This module has some common things that map between
      # controls in the WxRuby universe

      module Common
        def title
          get_title
        end

        def title=(title)
          set_title(title)
        end
      end
    end
  end
end
