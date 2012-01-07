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
# File:     view_model_template.rb
# Created:  Mon 12 Dec 2011 06:30:57 CST
#
#####################################################################
#++ 

module RubyMVC
module Models

  # This class provides a proxy for Model instances that
  # allows them to control the visibility of which properties
  # are exposed for a given view.  ViewModelTemplate instances can
  # be reused across view instances where the same properties
  # are to be exposed.
  #
  # The ViewModelTemplate class implements the same interface as
  # Model instances so that they can be used as drop-in
  # replacements everywhere a model instance can be used.
  #
  # The key difference is that the ViewModelTemplate exists outside
  # of any particular model instances, allowing the same view
  # binding to work for numerous concrete model instances,
  # effectively speifying the template through which the model
  # may be accessed.
  
  class ViewModelTemplate
    # When the ViewModelTemplate is initialized, it requires a set
    # of options and/or an optional initializer block that is
    # executed within the scope of the newly created instance.

    def initialize(options = {}, &block)
      @options = options
      @labels = []
      @options[:editable] ||= {}
      @options[:properties] ||= []
      self.instance_eval(&block) if block
    end

    def keys
      @options[:properties]
    end

    # Implement the Model#labels method in terms of the
    # template definition

    def labels
      @labels
    end

    # Implement the Model#is_editable? method in terms of the
    # template definition.  If the template doesn't further
    # restrict the behavior, the model's definition is used
    # instead.

    def is_editable?(key)
      k = key.to_sym
      if @options[:editable].has_key? k
        @options[:editable][k]
      else
        true
      end
    end

    # This method is used to mark a property key editable or
    # not through the view.  This method does not impact the
    # editability of the underlying model

    def editable(key, val = true)
      @options[:editable][key.to_sym] = val
    end

    # This method is used to mark a property visible or not
    # through the view.

    def property(key, options = {})
      puts "options: #{options.inspect}"
      key = key.to_sym
      
      if false == options[:show]
        show = false
      else
        show = true
      end

      editable(key, false) if false == options[:editable]

      if show && !@options[:properties].include?(key)
        @options[:properties] << key
        l = options[:alias] || key.to_s.capitalize
        @labels << options.merge({ :key => key, :label => l })
      elsif !show
        @options[:properties].delete(key)
        @labels.delete_if do |k|
          k[:key] == key
        end
      end
    end

    # This method is used to apply the template to a specific,
    # concrete model instance, creating a clone of the
    # template in the process so that multiple different
    # models can be used with the same template definition.

    def apply(model)
      @model = model
      self.clone
    end

    def method_missing(m, *args, &block)
      if @model
        @model.send(m, *args, &block)
      else
        super
      end
    end
  end

end
end
