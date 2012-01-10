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
# File:     frame.rb
# Created:  Wed 23 Nov 2011 10:46:44 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
    module WxRuby
      class Frame < Wx::Frame
        include Toolkit::SignalHandler
        include Common
        Toolkit::Frame.peer_class = self

        def initialize(options)
          opts = {}
          opts[:title] = options[:title]
          opts[:size] = [ options[:width], options[:height] ]
          if parent = options[:parent]
            parent = parent.peer
          end
          super(parent, opts)
          if icon = options[:icon]
            self.set_icon WxRuby.load_icon(icon)
          end
          @action_index = {}

          evt_close do |e|
            e.skip
            signal_emit("window-closed", self)
          end
        end

        # This method is used to add a child to the existing
        # frame.

        def add(child, options = {})
          child.peer.reparent(self)
          
          if child.is_a?(RubyMVC::Views::View) && (a = child.actions)
            child.frame = self
            merge_actions(a)
          end
        end

        def merge_actions(actions)
#          puts "#merge_actions #{actions.inspect}"
          tb = toolbar
          actions.each do |a|
            i = @action_index.size
#            puts "Action: #{a.label}"
            case a[:icon]
            when :stock_new
              artid = Wx::ART_NEW
            when :stock_edit
              artid = Wx::ART_NORMAL_FILE
            when :stock_delete
              artid = Wx::ART_DELETE
            when :stock_home
              artid = Wx::ART_GO_HOME
            when :stock_back
              artid = Wx::ART_GO_BACK
            when :stock_forward
              artid = Wx::ART_GO_FORWARD
            when :stock_reload
              artid = Wx::ART_REDO
            end
            if artid
              icon = Wx::ArtProvider.get_bitmap(artid, Wx::ART_TOOLBAR, [ 16, 16 ])
            else
              icon = Wx::NULL_BITMAP
            end

            tb.add_tool(i, a.label, icon)
            tb.enable_tool(i, a.sensitive)
            a.signal_connect("property-changed") do |a, key, old, val|
#              puts "property changed: #{key} => #{val}"
              tb.enable_tool(i, val)
            end
            evt_tool(i) do |event|
#              puts "Action[#{i}] triggered: #{a.key}"
              a.call
            end
            @action_index[a.key] = i
          end
          @toolbar.realize

#          puts "action_index: #{@action_index.inspect}"
        end

        def unmerge_actions(actions)
#          puts "unmerge actions: #{actions.inspect}"
          tb = toolbar
          actions.each do |a|
            idx = @action_index.delete(a.key)
#            puts "unmerge action[#{idx}] => #{a.inspect}"
            tb.delete_tool(idx) if idx
          end
        end
      
      protected
        def toolbar
          if !@toolbar
            @toolbar = create_tool_bar(
                Wx::TB_HORIZONTAL |
                Wx::TB_FLAT |
                Wx::TB_TEXT)
          end
          @toolbar
        end
      end
    end
  end
end
