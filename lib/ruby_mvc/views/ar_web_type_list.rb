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
# File:     ar_web_type_list.rb
# Created:  Mon  9 Jan 2012 15:56:18 GMT
#
#####################################################################
#++ 

module RubyMVC
module Views

  class ActiveRecordWebTypeList < WebContentTableView
    signal "add-row"

    def initialize(entity_type, options = {}, &block)
      @model = Models::ActiveRecordTableModel.new(entity_type, options)
      if options.is_a? Hash
        @template = options[:template]
      else
        @template = options
        options = {}
      end
      super((@template ? @template.apply(@model) : @model), options)
      
      action(:add, :label => "Add #{entity_type}", :icon => :stock_new) do
        signal_emit("add-row", self, entity_type)
      end
     
     action(:edit, :label => "Edit", :icon => :stock_edit, &block)
    end
  end

end
end
