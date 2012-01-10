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
# File:     messagebox.rb
# Created:  Mon  9 Jan 2012 11:34:52 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby
      class MessageBox < Wx::MessageDialog
        include Common
        Toolkit::MessageBox.peer_class = self

        def initialize(message, options)
          opts = {}
          title = options[:title] || "Message"
          if parent = options[:parent]
            parent = parent.peer
          end
          case(options[:class])
          when :error
            flags = Wx::OK | Wx::ICON_ERROR
          when :info
            flags = Wx::OK | Wx::ICON_INFORMATION
          when :question
            flags = Wx::YES_NO | Wx::ICON_QUESTION
          else
            flags = Wx::OK | Wx::CANCEL
          end
          super(parent, message.to_s, title, flags)
        end

        def show
          show_modal
        end
      end
    end
  end
end
