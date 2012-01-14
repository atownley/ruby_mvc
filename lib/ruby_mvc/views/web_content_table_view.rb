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
# File:     web_content_table_view.rb
# Created:  Tue  3 Jan 2012 00:48:54 CET
#
#####################################################################
#++ 

module RubyMVC
module Views

  # This is a WebContentView used to render table model
  # instances as HTML

  class WebContentTableView < WebContentView
    def render
      html = ""
      if t = @options[:title]
        html << "<h2>" << t << "</h2>"
      end

      r = @options[:renderer] || Renderers::Html4TableModelRenderer
      html << r.render(@model, @options)
    end
  end

end
end
