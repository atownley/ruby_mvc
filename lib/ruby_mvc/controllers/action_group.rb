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
# File:     action_group.rb
# Created:  Sun  1 Jan 2012 17:32:19 CET
#
#####################################################################
#++ 

module RubyMVC

  # This class provides a collection for actions so that they
  # can be more easily managed.  ActionGroups form the basis
  # for creating menus, toolbars and similar control groups.

  class ActionGroup
    def initialize
      @actions = []
      @index = {}
    end

    # This method is used to retrieve an action by action key.

    def [](key)
      @index[key]
    end

    def <<(action)
      if !@actions.include? action
        @actions << action
        @index[action.key] = action
      end
    end

    def delete(action)
      if action.is_a? Symbol
        key = action
      else
        key = action.key
      end
      val = @index.delete(key)
      @actions.delete(val)
    end

    def each(&block)
      @actions.each(&block)
    end

    def each_with_index(&block)
      @actions.each_with_index(&block)
    end
  end

end
