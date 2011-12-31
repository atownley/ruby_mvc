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
# File:     form_view.rb
# Created:  Fri 30 Dec 2011 14:48:46 CET
#
#####################################################################
#++ 

module RubyMVC
module Views

  # FormView instances are an abstract representation of a
  # form-based editor for model instances.  It is deliberately
  # modelled on HTML forms where possible.

  class FormView < View
    # This signal is emitted by the hosting widget when the
    # form has been submitted.  The block is passed arguments
    # for the form and the model (or model proxy) being used.

    signal "form-submit", :vetoable => true

    # This signal is emitted by the hosting widget when the
    # form has been reset.

    signal "form-reset"

    def initialize(model, &block)
      @model = model
      @editors = {}
      @validators = {}
      @disabled = {}
      self.instance_eval(&block) if block
    end

    def editor(key, editor)
      @editors[key.to_sym] = editor
    end

    # This method sets a validator block for the given key.
    # More than one validator can be initialized for each
    # property key

    def validator(key, &block)
      return if !block
      vals = (@validators[key.to_sym] ||= [])
      vals << block
    end

    # This method is used to ensure that the specified model
    # key field appears, but is disabled.  This can also be
    # done via the model by ensuring editable is false.

    def disabled(key, val = true)
      @disabled[key.to_sym] = val
    end

    # This method is used by the concrete hosting widget to
    # iterate through the form field definitions so that it
    # can create the actual UI form.

    def layout(&block)
      @model.labels.each do |l|
        k = l[:key]
        if (@disabled.has_key?(k) && @disabled[k]) \
            || !@model.is_editable?(k)
          disabled = true
        else
          disabled = false
        end
        block.call(k, l[:label], @model[k], @editors[k], disabled)
      end
    end

    # This method is called when the form should be saved to
    # the underlying model.

    def submit(values)
      values.each do |k, v|
        @model[k] = v if @model.is_editable? k
      end
      signal_emit("form-submit", self, @model)
    end

    def reset(&block)
      @model.keys.each do |k|
        block.call(k, @model[k])
      end
      signal_emit("form-reset", self, @model)
    end
  end

end
end
