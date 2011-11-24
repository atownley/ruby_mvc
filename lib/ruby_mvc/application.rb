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
    attr_accessor :frame
    attr_accessor :controller

    def initialize(options, &block)
      self.frame = Toolkit::Frame.new(options)
      if cc = options[:controller]
        self.controller = cc
        self.controller.app = self
        self.controller.init
      end
      self.instance_eval(&block) if block
      self.frame.show
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
