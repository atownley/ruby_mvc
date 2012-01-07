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
# File:     application.rb
# Created:  Wed 23 Nov 2011 11:01:20 GMT
#
######################################################################
#++

module RubyMVC

  # This provides the entry point for a basic application.
  class Application
    # FIXME 2011-12-29 ast:  The relationship between
    # Toolkit::App and the AppController classes don't really
    # make sense.  This needs to be revisited in a future
    # iteration.

    attr_accessor :frame
    attr_accessor :controller
    attr_accessor :windows

    def initialize(options, &block)
      @windows = []
      @windows << (self.frame = Toolkit::Frame.new(options))
      if cc = options[:controller]
        self.controller = cc
        self.controller.app = self
        self.controller.init
      end
      @frame_width = options[:width]
      @frame_height = options[:height]
      self.instance_eval(&block) if block
      self.frame.show
    end

    def window(options, &block)
      if !options[:parent]
        options[:parent] = self.frame
      end

      # FIXME: this is a bit of a hack for wxRuby peers
      options[:height] = @frame_height if !options[:height]
      options[:width] = @frame_width if !options[:width]
      win = Toolkit::Frame.new(options)
      block.call(win) if block
      win.show

      # FIXME: need to be able to intercept the close event so
      # we can remove the window from the list
      @windows << win
      win
    end

    def dialog(options, &block)
      if !options[:parent]
        options[:parent] = self.frame
      end

      dlg = Toolkit::Dialog.new(options)
      block.call(dlg) if block
      dlg.show
      dlg
    end
  end

  # This method creates a default application and runs it
  # using the active toolkit.
  
  def self.app(*args, &block)
    Toolkit::App.new do
      Application.new(*args, &block)
    end
  end
end
