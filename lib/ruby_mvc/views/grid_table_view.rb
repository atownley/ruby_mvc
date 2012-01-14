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
# File:     grid_table_view.rb
# Created:  Sun  1 Jan 2012 17:08:34 CET
#
#####################################################################
#++ 

module RubyMVC
module Views

  # This class is used to provide a default binding between
  # a table model instance and a GridView.

  class GridTableView < PeerView
    widget Toolkit::GridView

    # This signal is triggered when the row edit action is
    # triggered via either a double-click on the row or when
    # either the toolbar or menu item is triggered.  Arguments
    # are the sender view, the view model, the row index and
    # the row model to be edited

    signal "row-edit"

    def initialize(model, options = {}, &block)
      super(options, &block)

      # initialize the default state of the peer widget
      widget.model = model
      widget.editable = options[:editable]

      # Create the actions for the model
      action(:new, :label => "New row", :icon => :stock_new) do
        model.insert_rows(-1, model.create_rows)
        idx = model.size - 1
        signal_emit("row-edit", self, model, idx, model[idx])
      end

      action(:delete, 
              :label => "Delete", 
              :enable => :select_multi,
              :icon => :stock_delete
              ) do
#        puts "rows: #{widget.selected_rows.inspect}"
        widget.selected_rows.reverse_each do |i|
          model.remove_row(i)
        end
      end

      action(:edit,
              :label => "Edit...",
              :enable => :select_single,
              :icon => :stock_edit
              ) do
        idx = widget.selected_rows.first
        row = model[idx]
        signal_emit("row-edit", self, model, idx, row)
      end

      widget.signal_connect("row-selection-changed") do |s, m, rows|
#        puts "selection changed: #{rows.inspect}"
        @actions.each do |a|
          a.selection(s, m, rows)
        end
      end

      widget.signal_connect("row-activated") do |s, m, r, k|
        row = model[r]
        signal_emit("row-edit", self, model, r, row)
      end

#      puts "self.class.signals: #{self.class.signals.keys.inspect}"
#      puts "widget.class.signals: #{widget.class.signals.keys.inspect}"
    end
  end

end
end
