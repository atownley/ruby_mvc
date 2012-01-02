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
# File:     grid_view.rb
# Created:  Sat 31 Dec 2011 18:59:06 CET
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
  
    class GridView < Widget
      api_methods :model=, :editable=, :selected_rows

      # This method is used to inform the listener that the
      # specified row in the view was "activated" (normally, a
      # double-click on the row).  Arguments are the sender,
      # the model, the row and the column activated.

      signal "row-activated"

      # This method is used to monitor changes in the selected
      # rows of the grid.  Arguments are the sender, the model
      # and the row indexes selected.

      signal "row-selection-changed"
    end
  end
end
