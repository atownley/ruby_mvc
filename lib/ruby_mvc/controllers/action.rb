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
# File:     action.rb
# Created:  Sun  1 Jan 2012 16:44:29 CET
#
#####################################################################
#++ 

module RubyMVC

  # This class provides the ability to define discrete
  # operations a la the Command pattern.  Actions have keys,
  # labels and a block that is called when they are activated.
  # Additionally, they may be initialized with options that
  # define when they are available.

  class Action
    include Toolkit::PropertyChangeNotifier
    attr_reader :key

    def initialize(key, options = {}, &block)
      @key = key.to_sym
      @options = options
      @block = block
      @sensitive = true
      @sensitive = false if !@options[:enable].nil?
      if !(x = options[:sensitive]).nil?
        @sensitive = x
      end
    end

    # This method is used to access the options for this
    # action.

    def [](key)
      @options[key]
    end

    def label
      @options[:label] || @key.to_s.capitalize
    end

    def call(*args)
      @block.call(*args) if @block
    end

    def sensitive=(val)
      if val != @sensitive
        @sensitive = val
        property_changed(:sensitive, !val, val)
      end
    end

    # This method may be overridden by action instances to
    # have more control over when the action should be enabled
    # or not.

    def sensitive
      @sensitive
    end

    # This method is used to allow the action instances to
    # determine internal state changes based on selection
    # state changes in their view.

    def selection(sender, model, sel)
      case @options[:enable]
      when :select_multi
        self.sensitive = sel.size >= 1
      when :select_single
        self.sensitive = sel.size == 1
      end
    end
  end

end
