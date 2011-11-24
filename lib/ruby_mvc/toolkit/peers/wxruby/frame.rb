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
# File:     frame.rb
# Created:  Wed 23 Nov 2011 10:46:44 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby
      class Frame < Wx::Frame
        include Common
        Toolkit::Frame.peer_class = self

        def initialize(options)
          opts = {}
          opts[:title] = options[:title]
          opts[:size] = [ options[:width], options[:height] ]
          super(options[:parent], opts)
        end

        # This method is used to add a child to the existing
        # frame.

        def add(child, options = {})
          child.peer.reparent(self)
        end
      end
    end
  end
end
