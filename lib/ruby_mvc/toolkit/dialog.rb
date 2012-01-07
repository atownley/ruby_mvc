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
# File:     dialog.rb
# Created:  Wed 23 Nov 2011 10:41:15 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
  
    class Dialog < Widget
      def add(w)
        # FIXME: this is a cheezy way to do this...
        if w.is_a? RubyMVC::Views::FormView
          peer.add_form(w)
        elsif w.is_a? RubyMVC::Views::View
          peer.add_view(w)
        else
          peer.add(w)
        end
      end
    end
  end
end
