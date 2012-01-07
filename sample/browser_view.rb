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
# File:     browser_view.rb
# Created:  Mon  2 Jan 2012 23:03:17 CET
#
######################################################################
#++

require 'mvc'
include RubyMVC

# NOTE: this is a simple, in-line test.  You wouldn't really
# do it this way in a real application.

RubyMVC.app :title => "BrowserView Sample", :width => 800, :height => 600 do
  data = [
    { :id => 1, :fname => "Bob", :lname => "Jones" },
    { :id => 2, :fname => "Leslie", :lname => "Smith" },
    { :id => 3, :fname => "Jake", :lname => "Bennigan" }
  ]

  model = Models::HashArrayTableModel.new(data)
  template = Models::ViewModelTemplate.new do
    property :id, :alias => "ID", :editable => false
    property :fname, :alias => "First name"
    property :lname, :alias => "Last name"
  end
  web_table = Views::WebContentTableView.new(template.apply(model))
  
  browser = Views::BrowserView.new
  frame.add(browser)

  browser.open "test.html"
  browser.load_html("<h1>Hello</h1>", "internal:hello")
  browser.load(web_table)
  browser.signal_connect("navigation-requested") do |s, href, t|
    puts "navigation requested: #{href}"
    s.open href
  end
end
