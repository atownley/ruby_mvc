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
# File:     web_view.rb
# Created:  Wed 23 Nov 2011 17:08:02 GMT
#
#####################################################################
#++ 

module RubyMVC
module Views

  # This is a more sophisticated view control vs. the standard
  # toolkit widget.

  class WebView < View
    widget Toolkit::WebView

    # This method is used to load the view with the
    # information in the table model.

    def load(model, options = {}, &block)
      cols = columns(model, options)
      if r = options[:renderer]
        html = r.render(model, cols, options[:renderer_options])
        puts "HTML:\n#{html}"
        widget.load_html(html)
      else
        raise ArgumentError,"renderer not specified"
      end
    end

  protected
    # This method extracts or creates the column model for the
    # view.

    def columns(model, options)
      if cols = options[:columns]
        cols
      else
        cols = model.keys.collect do |k|
          { :key => k.to_sym, :label => "#{k.capitalize}" }
        end
      end
    end
  end

end
end
