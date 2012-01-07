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
# Created:  Wed 23 Nov 2011 12:54:26 GMT
#
#####################################################################
#++ 

module RubyMVC
  module Toolkit
 
    # This class provides a web/HTML view whose API is
    # modelled on WebKit

    class WebView < Widget
      api_methods :load_html, :append_html
      api_methods :can_go_back?, :go_back
      api_methods :can_go_forward?, :go_forward
      api_methods :open, :reload, :go_home, :location
      api_methods :stop_loading, :is_loading?

      # This signal is emitted when the user requests
      # navigation to another web resource.

      signal "navigation-requested", :vetoable => true

      # This signal is emitted when the title of the content
      # in the view changes

      signal "title-changed"

      # This signal is emitted when the page begins to load

      signal "load-started"

      # This signal is emitted when the page load has
      # completed.

      signal "load-finished"
    end

  end
end
