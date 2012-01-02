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
# Created:  Sun 11 Dec 2011 14:37:40 CST
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby
      class GridView < Wx::Grid
        include SignalHandler
        include Common
        Toolkit::GridView.peer_class = self

        def initialize(options = {})
          puts "options: #{options.inspect}"
          super(WxRuby.parent(options), options[:id] || -1)
          if false == options[:show_row_labels]
            set_row_label_size(0)
          end
          @selected_rows = []

          evt_grid_cmd_cell_left_dclick(self.get_id()) do |e|
            if @gm
              col = @gm.get_key(e.get_col)
            else
              col = e.get_col
            end
            signal_emit("row-activated", self, @model, e.get_row, col)
          end

          evt_grid_range_select do |e|
            puts "Event alt: #{e.alt_down}; ctrl: #{e.control_down}; brc: #{e.get_bottom_right_coords}; bottom: #{e.get_bottom_row}; left: #{e.get_left_col}; right: #{e.get_right_col}; tlc: #{e.get_top_left_coords}; top: #{e.get_top_row}; meta: #{e.meta_down}; selecting: #{e.selecting}; shift: #{e.shift_down}" if !e.selecting
            next if !e.selecting

            # FIXME: this should be a bit more clever in the
            # future, but right now, we're only dealing with
            # row selection
#            puts "Event alt: #{e.alt_down}; ctrl: #{e.control_down}; brc: #{e.get_bottom_right_coords}; bottom: #{e.get_bottom_row}; left: #{e.get_left_col}; right: #{e.get_right_col}; tlc: #{e.get_top_left_coords}; top: #{e.get_top_row}; meta: #{e.meta_down}; selecting: #{e.selecting}; shift: #{e.shift_down}"
            top = e.get_top_row
            bottom = e.get_bottom_row
            sel = []
            top.upto(bottom) do |i|
              sel << i
            end
            @selected_rows = sel
            signal_emit("row-selection-changed", self, @model, sel)
          end
        end

        def model=(model)
          @model = model
          @gm = GridModel.new(model)
          set_table(@gm, Wx::Grid::GridSelectRows)

          # FIXME: this is a bit cheezy and there should be a
          # better way to communicate between the grid table
          # and the view than this...  Apparently, the wxRuby
          # implementation doesn't expose the message
          # dispatching required between GridTableBase and the
          # Grid displaying it.  Kinda defeats the point...

          @model.signal_connect("rows-inserted") do |s, i, r|
            puts "refresh rows-inserted"
            @gm = GridModel.new(model)
            set_table(@gm, Wx::Grid::GridSelectRows)
          end
          @model.signal_connect("rows-removed") do |s, r|
            puts "refresh rows-removed"
            @gm = GridModel.new(model)
            set_table(@gm, Wx::Grid::GridSelectRows)
          end
          @model.signal_connect("row-updated") do |s, i, r|
            puts "refresh row-updated"
            @gm = GridModel.new(model)
            set_table(@gm, Wx::Grid::GridSelectRows)
          end
        end

        def set_table(table, flags)
          super
          @selected_rows.clear
          signal_emit("row-selection-changed", self, @model, @selected_rows)
        end

        def editable=(val)
          enable_editing(val)
        end

        def selected_rows
          # FIXME: I shouldn't have to maintain this list...
          @selected_rows
        end
      end
    end
  end
end
