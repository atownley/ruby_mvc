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
# File:     dialog.rb
# Created:  Sun 11 Dec 2011 14:37:40 CST
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby
      class Dialog < Wx::Dialog
        include Common
        Toolkit::Dialog.peer_class = self

        def initialize(options)
          opts = {}
          title = options[:title] || "Dialog"
          winid = options[:id] || -1
          opts[:size] = [ options[:width], options[:height] ]
          if parent = options[:parent]
            parent = parent.peer
          end
          if options[:modal].nil? || options[:modal]
            @modal = true
          else
            @modal = false
          end
          super(parent, winid, title)
          @buttons = create_separated_button_sizer(Wx::OK|Wx::CANCEL)
        end

        # This method is used to add a child to the existing
        # frame.

        def add(child, options = {})
          child.peer.reparent(self)
        end

        # This method is used to add a FormView to the main
        # content part of the dialog

        def add_form(form)
          @wxform = FormBuilder.build(self, form)
          @wxform.widget.add(@buttons, 0, Wx::ALIGN_RIGHT|Wx::ALL, 5)
          self.sizer = @wxform.widget
          self.sizer.fit(self)
        end

        def show
          self.centre
          if @modal
            if Wx::ID_OK == self.show_modal()
              @wxform.submit if @wxform
            end
          else
            sel.show()
          end
        end
      end

    private
    end
  end
end
