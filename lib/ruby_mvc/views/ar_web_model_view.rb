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
# File:     ar_web_model_view.rb
# Created:  Mon  9 Jan 2012 22:45:05 GMT
#
#####################################################################
#++ 

module RubyMVC
module Views

  class ActiveRecordWebModelView < WebModelView
    signal "row-edit"
    signal "row-delete", :vetoable => true

    def initialize(row, options = {})
      super

      action(:edit, :label => "Edit", :icon => :stock_edit) do
        signal_emit("row-edit", self, row)
      end

#      action(:delete, :label => "Delete", :icon => :stock_delete) do
#        signal_emit("row-delete", self, row)
#      end
    end

    def render
      html = super
      tagz {
        tagz.concat html
        tagz.concat render_links
      }
    end

  protected
    def render_links
    end
  end

end
end
