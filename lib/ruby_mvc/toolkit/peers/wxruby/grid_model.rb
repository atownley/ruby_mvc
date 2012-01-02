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
# File:     grid_model.rb
# Created:  Sat 31 Dec 2011 18:29:03 CET
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby

      # This class provides an adapter between a
      # RubyMVC::Models::TableModel instance and the
      # Wx::GridTableBase API so that we can drive Wx::Grid
      # instances using our model definitions.

      class GridModel < Wx::GridTableBase
        def initialize(model)
          super()
          @model = model
          @labels = model.labels
          @cols = {}
          @labels.each_with_index do |l, i|
            @cols[i] = l[:key]
          end
        end

        def get_number_cols
          @model.labels.size
        end

        def get_number_rows
          @model.size
        end

        def get_value(row, col)
          @model.value_for(row, get_key(col)).to_s
        end

        def is_empty_cell(row, col)
          get_value(row, col).nil?
        end

        def get_attr(row, col, kind)
        end

        def get_row_label_value(row)
          (row + 1).to_s
        end

        def get_col_label_value(col)
          @labels[col][:label]
        end

        def get_key(col)
          @cols[col]
        end
      end
    end
  end
end
