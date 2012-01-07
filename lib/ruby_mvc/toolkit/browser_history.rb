#--
######################################################################
#
# Copyright 2008-2012 Andrew S. Townley
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
# File:     browser_history.rb
# Created:  Sun Oct 19 17:08:26 IST 2008
#
#####################################################################
#++ 

module RubyMVC
module Toolkit

  # This class provides a mechanism for tracking browser
  # history operations where the underlying peer controls
  # don't do this well enough for our purposes (yes, I'm
  # looking at you Wx::HtmlWindow...)

  class BrowserHistory
    def initialize(maxsize = 100)
      @mutex = Mutex.new
      @history = []
      @maxsize = maxsize
      @index = 0
    end

    def <<(entry)
      @mutex.synchronize {
        return if @history[-1] == entry
        if @history.size >= @maxsize
          @history.delete(0)
        else
          @history = @history[0..@index]
        end
        @history << entry if @history[-1] != entry
        @index = @history.size - 1
#        dump_history
      }
    end

    def current
      @mutex.synchronize { @history[@index] }
    end

    def has_prev?
      @index > 0
    end

    def has_next?
      @index < @history.size - 1
    end

    def prev
      @mutex.synchronize {
        if has_prev?
          @index -= 1
        end
#        dump_history
      }
      current
    end

    def next
      @mutex.synchronize {
        if has_next?
          @index += 1
        end
#        dump_history
      }
      current
    end

    def each(&block)
      @mutex.synchronize {
        @history.each(&block)
      }
    end

    def reverse_each(&block)
      @mutex.synchronize {
        @history.reverse_each(&block)
      }
    end

  private
    def dump_history
      puts "HISTORY ---"
      @history.each_index do |index|
        if @index == index
          puts ">> #{@history[index]}"
        else
          puts "   #{@history[index]}  "
        end
      end
      puts "---"
    end
  end

end
end
