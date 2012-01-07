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
# File:     array_table_model.rb
# Created:  Sat 19 Nov 2011 19:56:17 GMT
#
#####################################################################
#++ 

module RubyMVC
module Models

  # This class provides an adapter to expose an array of
  # hashes or anything else that responds to the #keys, #[]
  # and #[]= methods as a TableModel instance.
  #
  # Note that the keys of the objects in the array will be
  # requested as symbols and not as any other object type.

  class HashArrayTableModel < TableModel
    def initialize(data, options = {})
      raise ArgumentError, "argument not an Array" if !data.is_a? Array
      super(options)

      @options = options
      @data = data
    end

    def create_rows(count = 1)
      if f = @options[:row_factory]
        f.call(count)
      else
        r = []
        t = @options[:row_template] || @data.last
        count.times { r << t.clone }
        r
      end
    end

    def insert_row(index, row)
      @data.insert(index, row)
      super(index, Model.adapt(row, @options))
    end

    def insert_rows(index, rows)
      @data.insert(index, *rows)
      super(index, rows.collect { |r| Model.adapt(r, @options) })
    end
    
    def remove_row(index)
      row = Model.adapt(@data.delete_at(index), @options)
      signal_emit("rows-removed", self, index, [ row ])
      row
    end

    def remove_rows(index, count)
      rows = []
      count.times do
        rows << Model.adapt(@data.delete_at(index), @options)
      end
      signal_emit("rows-removed", self, index, rows)
      rows
    end

    def update_row(index, row)
      @data[index] = row
      super(index, Model.adapt(row, @options))
    end

    # The keys used will come from the first element in the
    # array or be empty if the array is empty.

    def keys
      if @data.size > 0
        @data.first.keys
      else
        {}
      end
    end

    def value_for(row, key)
      @data[row][key.to_sym]
    end

    def [](row)
      @data[row]
    end

    # Iterates over each of the elements in the array and
    # provides a Model instance to the caller based on the
    # keys contained in the object itself.

    def each(&block)
      return if !block

      @data.each do |x|
        block.call(Model.adapt(x, @options))
      end
    end

    def each_with_index(&block)
      return if !block

      @data.each_with_index do |x, i|
        block.call(Model.adapt(x, @options), i)
      end
    end
  end

end
end
