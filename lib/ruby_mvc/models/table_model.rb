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
# File:     table_model.rb
# Created:  Sat 19 Nov 2011 18:13:40 GMT
#
#####################################################################
#++ 

module RubyMVC
module Models

  # The TableModel class expands the concepts of the Model
  # class to a number of related rows with the same properties
  # defined for the model.

  class TableModel < Model
    # This signal is triggered when contiguous rows are
    # inserted into the model.  The arguments are the sender
    # model, the insertion index and the row models that were
    # inserted.
    
    signal "rows-inserted"

    # This signal is triggered when contiguous rows are
    # removed from the model.  The arguments are the index at
    # which the removal took place and the row models that
    # were removed from the model.

    signal "rows-removed"

    # This signal is triggered when an existing row has been
    # changed.  The arguments are the sender, the index and
    # the changed row model

    signal "row-changed"

    # This method is used to create a number of row data
    # elements that will be inserted into the model at the
    # specified location using the #insert_row or #insert_rows
    # method.
    #
    # The result is an array of row data instances in whatever
    # format is deemed suitable for the model instance to
    # create.

    def create_rows(count = 1)
    end

    # This method is used to insert a single row into the
    # model at the given row index.

    def insert_row(index, row)
      signal_emit("rows-inserted", self, index, [ row ])
    end

    # This method is used to insert an array of row objects
    # into the model at the specified index

    def insert_rows(index, rows)
      signal_emit("rows-inserted", self, index, rows)
    end

    # This method is used remove a single row from the model
    # and return a reference to the row model removed to the
    # caller.
    #
    # Note, the derived classes are responsible for emitting
    # the appropriate signal since the data access is opaque
    # to the base class.

    def remove_row(index)
    end

    # This method is used remove multiple rows from the model
    # and return a reference to the row models removed to the
    # caller.
    #
    # Note, the derived classes are responsible for emitting
    # the appropriate signal since the data access is opaque
    # to the base class.

    def remove_rows(index, count)
    end

    # This method is used to update the specified row in the
    # model and ensure that the appropriate notifications for
    # all linked views are sent.

    def update_row(index, row)
      signal_emit("row-changed", index, row)
    end

    # This method will iterate over each of the rows and
    # provide the caller with a reference to the row instance,
    # which is also conformant with the Model API

    def each(&block)
    end

    # This method will iterate over each of rows and provide
    # the caller with a reference to the row instance as a
    # model and the index of the row.

    def each_with_index(&block)
    end

    # This method allows direct access into the model rows, in
    # row-major order for the specified, zero-based index and
    # property key

    def value_for(row, key)
    end

    # This method is used to retrieve the model instance for
    # the given row index

    def [](idx)
    end
  end

end
end
