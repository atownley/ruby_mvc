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
# File:     property_change_notifier.rb
# Created:  Mon  2 Jan 2012 12:52:02 CET
#
#####################################################################
#++ 

module RubyMVC
module Toolkit

  module PropertyChangeNotifier
    include Toolkit::SignalHandler
    extend Toolkit::SignalHandler::ClassMethods

    # this signal is emitted when any property is changed on
    # the model.  The arguments are the sender, the old and
    # the new values

    signal "property-changed"

  protected
    def property_changed(key, old, val)
      signal_emit("property-changed", self, key, old, val)
    end
  end

end
end
