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
# File:     ar_web_row_view.rb
# Created:  Mon  9 Jan 2012 15:56:18 GMT
#
#####################################################################
#++ 

module RubyMVC
module Views

  class WebModelView < WebContentView
    include Tagz

    def initialize(row, options = {})
      @model_type = row.class
      if options.is_a? Hash
        @template = options[:template]
      else
        @template = options
        options = {}
      end
      super((@template ? @template.apply(row) : row), options)
    end

    def render
      render_properties
    end

  protected
    def render_properties
      tagz {
        h2_(@model_type)
        table_(:border => 1, :cellspacing => 0) {
          @model.labels.each do |l|
            k = l[:key]
            tr_ {
              th_(:valign => "top", :align => "left") {
                strong_ l[:label]
              }
              td_(:align => "top") {
                @model[k]
              }
            }
          end
        }
      }
    end
  end

end
end
