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
# File:     model.rb
# Created:  Fri 30 Dec 2011 12:46:32 CET
#
#####################################################################
#++ 

module RubyMVC
module Models

  # This class defines the generic API for models in RubyMVC.
  # Models expose key/value pairs to other parts of the
  # system, but they are more than simple Hash instances
  # because not all properties of a model are always editable.

  class Model
    include Toolkit::SignalHandler
    extend Toolkit::SignalHandler::ClassMethods

    # this signal is emitted when any property is changed on
    # the model.  The arguments are the sender, the old and
    # the new values

    signal "property-changed"

    # This method is used to use the Model class to adapt any
    # object that responds to the #keys, #size, #[] and #[]=
    # methods

    def self.adapt(obj, options = {})
      return obj if obj.is_a? Model
      self.new(options.merge({:data => obj}))
    end

    # The base model is backed by a simple Hash, and supports
    # specifying the following options for defining which
    # properties are editable or not.

    def initialize(options = {})
      @data = options.delete(:data) || {}
      @options = options
    end

    # This method is used to provide the property keys of the
    # model as symbols.

    def keys
      @data.keys.sort.collect { |k| k.to_sym }
    end

    # This method is used to retrieve the property key and the
    # display label for the key to be used by views when
    # displaying model data.

    def labels
      @labels = {}
      self.keys.collect do |k|
        x = { :key => k.to_sym, :label => k.to_s.capitalize }
        @labels[x[:key]] = x[:label]
        x
      end
    end

    # This method provides information about inter-model links
    # to provide built-in support for master-detail types of
    # relationships between models.

    def link_labels
      {}
    end

    # This method is used to check whether a property key is
    # editable or not

    def is_editable?(key)
      (@options[:editable] || {})[key.to_sym] || true
    end

    def [](key)
      @data[key.to_sym]
    end

    def []=(key, val)
      k = key.to_sym
      old = @data[k]
      @data[k] = val

      if old != val
        signal_emit("property-changed", self, k, old, val)
      end
    end

    def size
      @data.size
    end

    # This method is used to iterate over the properties of
    # the model.  For each property, the key, label and value
    # are provide as arguments to the block

    def each_label(&block)
      labels.each do |l|
        block.call((k = l[:key]), l[:label], @data[k])
      end
    end

    # This method is used to retrieve the label for the
    # specified model key.

    def label_for(key)
      if !@labels
        labels
      end
      @labels[key.to_sym]
    end
  end

end
end
