#--
######################################################################
#
# Copyright 2011-2012 Andrew S. Townley
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
# File:     hyperlink_cell_renderer.rb
# Created:  Mon  9 Jan 2012 17:47:19 GMT
#
#####################################################################
#++ 

require 'tagz'

module RubyMVC
  module Renderers

    class HyperlinkCellRenderer
      include Tagz

      def render(widget, row, col)
        lk = col[:hl_label_key] || col[:key]
#        puts "LK: #{lk.inspect}; row: #{row.inspect}"
        text = row[lk]
        href = col[:href]
        val = row[col[:href_key] || col[:key]]
        tagz {
          td_(:valign => "top") {
            a_ text, :href => "#{href}#{val}"
          }
        }
      end
    end

  end
end
