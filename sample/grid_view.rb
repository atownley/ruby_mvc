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
# Created:  Sat 31 Dec 2011 19:04:31 CET
#
######################################################################
#++

require 'mvc'
include RubyMVC

# NOTE: this is a simple, in-line test.  You wouldn't really
# do it this way in a real application.

RubyMVC.app :title => "GridView", :width => 800, :height => 600 do
  data = [
    { :id => 1, :fname => "Bob", :lname => "Jones" },
    { :id => 2, :fname => "Leslie", :lname => "Smith" },
    { :id => 3, :fname => "Jake", :lname => "Bennigan" }
  ]

  model = Models::HashArrayTableModel.new(data)
  grid = Toolkit::GridView.new(:show_row_labels => false)
  grid.editable = false
  grid.model = model
  frame.add(grid)
end
