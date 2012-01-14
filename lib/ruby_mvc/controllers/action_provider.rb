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
# File:     action_provider.rb
# Created:  Sat 14 Jan 2012 13:16:53 GMT
#
#####################################################################
#++ 

module RubyMVC

  # This module is used to provide actions to toolkit widget
  # implementations for appropriate rendering based on the
  # widget type.

  module ActionProvider
    attr_reader :actions

    def action(key, options = {}, &block)
      @actions ||= ActionGroup.new
      a = Action.new(key, options, &block)
      @actions << a
      a
    end
  end

end