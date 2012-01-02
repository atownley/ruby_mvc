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
# File:     grid_table_view.rb
# Created:  Mon  2 Jan 2012 16:39:48 CET
#
######################################################################
#++

require 'mvc'
include RubyMVC

# NOTE: this is a simple, in-line test.  You wouldn't really
# do it this way in a real application.

RubyMVC.app :title => "GridTableView Sample", :width => 800, :height => 600 do
  data = [
    { :id => 1, :fname => "Bob", :lname => "Jones" },
    { :id => 2, :fname => "Leslie", :lname => "Smith" },
    { :id => 3, :fname => "Jake", :lname => "Bennigan" }
  ]

  model = Models::HashArrayTableModel.new(data, :row_template => {})
#  model.signal_connect("rows-inserted") do |s, idx, rows|
#    puts "insert #{rows.size} rows at #{idx}"
#    puts "Model: #{model.inspect}"
#  end
#  model.signal_connect("rows-removed") do |s, idx, rows|
#    puts "removed #{rows.size} rows"
#    puts "Model: #{model.inspect}"
#  end

  template = Models::ViewModelTemplate.new do
    property :id, :alias => "ID", :editable => false
    property :fname, :alias => "First name"
    property :lname, :alias => "Last name"
  end
  template.apply model

  grid = Views::GridTableView.new(template, 
                :show_row_labels => false, :editable => false)
  grid.signal_connect("row-edit") do |s, m, i, r|
    ft = template.clone
    ft.apply r
    form = Views::FormView.new(ft)
    form.signal_connect("form-submit") do |form, d|
      m.update_row(i, r)
    end
    dialog :title => "Row Editor", :parent => frame do |dlg|
      dlg.add(form)
    end
  end

  frame.add(grid)
end
