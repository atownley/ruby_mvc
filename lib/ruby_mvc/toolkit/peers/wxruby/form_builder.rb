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
# File:     form_builder.rb
# Created:  Fri 30 Dec 2011 17:20:42 CET
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby

      # This module is a helper class used to build the
      # concrete representations of the FormView controls

      class FormBuilder
        def self.build(parent, form)
          builder = self.new
          builder.build(parent, form)
          builder
        end

        def initialize
          @fields = {}
          @panel = Wx::BoxSizer.new(Wx::VERTICAL)
          @sizer = Wx::FlexGridSizer.new(0, 2, 5, 5)
          @panel.add(@sizer, 0, Wx::ALIGN_CENTER_VERTICAL|Wx::ALL, 5)
        end

        def widget
          @panel
        end

        def build(parent, form)
          @form = form
          form.layout do |key, label, val, editor, disabled|
          puts "key: #{key}; disabled: #{disabled}"
            case(editor)
            when :textarea
              w = build_textfield(parent, label, val, true)
            else
              w = build_textfield(parent, label, val)
            end
            @fields[key] = w
            w.disable if disabled
          end
        end

        def submit
          save_form
        end

      private
        def save_form
          vals = {}
          @fields.each do |k, v|
            if v && v.is_modified
              vals[k] = v.get_value
            end
          end
          @form.submit(vals)
        end

#        def load_form(model)
#          @fields.keys.each do |k|
#            @fields[k].set_value(model[k].to_s)
#          end
#        end

        def build_textfield(parent, label, val = "", multiline = false)
          if multiline
            flags = Wx::TE_MULTILINE
            size = [ 150, -1 ]
          else
            flags = 0
            size = [ 150, -1 ]
          end
          st = Wx::StaticText.new(parent, :label => label)
          tf = Wx::TextCtrl.new(parent, :value => val.to_s, :size => size, :style => flags)
          tf.evt_set_focus { |e| tf.set_selection(0, -1) }
          tf.evt_kill_focus { |e| tf.set_selection(0, 0) }
#          @sizer.add(st, 0, Wx::ALIGN_LEFT|Wx::ALL, 5)
#          @sizer.add(tf, 1, Wx::ALIGN_CENTER|Wx::ALL, 5)
          @sizer.add(st)
          @sizer.add(tf)
          tf
        end
      end
    end
  end
end
