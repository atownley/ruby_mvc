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
# File:     ar_type_editor.rb
# Created:  Mon 21 Nov 2011 18:00:49 GMT
#
#####################################################################
#++ 

module RubyMVC
module Views

  class ActiveRecordTypeEditor < GridTableView
    def initialize(app, parent, entity_type, options = {}, &block)
      options[:editable] = false
      options[:show_row_labels] = false
      @model = Models::ActiveRecordTableModel.new(entity_type)
      @template = options[:template]
      super((@template ? @template.apply(@model) : @model), options)
      signal_connect("row-edit") do |s, m, i, r|
        app.dialog(:title => options[:editor_title], :parent => parent) do |dlg|
          form = FormView.new((@template ?  @template.apply(r) : r), &block)
          form.signal_connect("form-submit") do |form, d|
            begin
              r.save!
              m.update_row(i, r)
            rescue ActiveRecord::RecordInvalid => e
              app.error(e, :title => "Validation Error", :parent => dlg)
            end
          end
          dlg.add form
        end
      end
    end
  end

end
end
