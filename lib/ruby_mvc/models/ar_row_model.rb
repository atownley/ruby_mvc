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
# File:     ar_row_model.rb
# Created:  Thu 12 Jan 2012 16:47:20 GMT
#
#####################################################################
#++ 

module RubyMVC
module Models

  # This class provides a Model adapter implementation for
  # ActiveRecordBase class instances.

  class ActiveRecordRowModel < Model
    def initialize(row, options = {})
      options[:data] = row
      super(options)
    end

    def entity_type
      @data.class
    end

    def keys
      @data.attributes.keys.collect { |k| k.to_sym }
    end

    # This method provides information about inter-model links
    # to provide built-in support for master-detail types of
    # relationships between models.

    def link_labels
      # FIXME: should probably implement this intelligently to
      # do some introspection magic
      {}
    end

    def size
      @data.attributes.keys.size
    end
  end

end
end
