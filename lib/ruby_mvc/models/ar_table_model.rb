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
# File:     ar_table_model.rb
# Created:  Sun 11 Dec 2011 10:38:34 CST
#
#####################################################################
#++ 

module RubyMVC
module Models

  # This class provides an adapter between the ActiveRecord
  # model classes and the RubyMVC TableModel interface.  This
  # class is designed to be able to provide access to either
  # all instances of a particular AR table or only a subset of
  # the rows matching a particular query.

  class ActiveRecordTableModel < TableModel
    attr_reader :keys

    def initialize(entity_type, rows = nil)
      super()
      @row_idx = []
      @entity_type = entity_type
      @rows = rows 
      @keys = @entity_type.attribute_names.sort

      # FIXME: this is a hack because I'm not sure how best to
      # ensure we have the rows we need
      self.each { |r| }
    end

    def create_rows(count = 1)
      rows = []
      count.times { rows << @entity_type.new }
      rows
    end

    def insert_row(index, row)
      @row_idx.insert(index, row)
      super(index, row)
    end

    def insert_rows(index, rows)
      if index == -1
        @row_idx.concat(rows)
      else
        rows.each_with_index do |row, i|
          @row_idx.insert(index + i, row)
        end
      end
      super(index, rows)
    end

    def remove_row(index)
      if row = @row_idx.delete_at(index)
        @entity_type.delete(row[@entity_type.primary_key])
        signal_emit("rows-removed", self, index, [ row ])
      end
      row
    end

    def remove_rows(index, count)
      rows = []
      count.times do
        rows << @row_idx.delete_at(index)
        @entity_type.delete(rows.last[@entity_type.primary_key])
      end
      signal_emit("rows-removed", self, index, rows)
      rows
    end

    def update_row(index, row)
      @row_idx[index] = row
      super
    end

    def [](index)
      @row_idx[index]
    end

    def each(&block)
      @row_idx.clear
      _rows.each do |row|
        @row_idx << row
        block.call(row)
      end
    end

    def each_with_index(&block)
      @row_idx.clear
      _rows.each_with_index do |row, i|
        @row_idx << row
        block.call(row, i)
      end
    end

    def value_for(row, key)
      @row_idx[row][key]
    end

    def size
      puts "idx.size: #{@row_idx.size}"
      [_rows.count, @row_idx.size].max
    end

  protected
    def _rows
      x = @rows || @entity_type.find(:all)
      puts "working with #{x.count} rows"
      x
    end
  end

end
end
