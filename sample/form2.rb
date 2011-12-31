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
# File:     form2.rb
# Created:  Sat 31 Dec 2011 13:30:53 CET
#
######################################################################
#++

require 'mvc'
include RubyMVC

# NOTE: this is a simple, in-line test.  You wouldn't really
# do it this way in a real application.

RubyMVC.app :title => "Simple Form", :width => 800, :height => 600 do
  model = Models::Model.new
  model[:id] = 1
  model[:fname] = "Jane"
  model[:lname] = "Doe"
  model[:description] = "Jane Doe is the hardest working individual I personally know.  She's amazing!"

  # The ViewModelTemplate specifies the order in which the
  # properties will be displayed, in addition to allowing the
  # definition of the property aliases and whether the
  # properties should be editable or not.

  template = Models::ViewModelTemplate.new do
    property :id, :alias => "ID", :editable => false
    property :fname, :alias => "First name"
    property :lname, :alias => "Last name"
  end
  template.apply model

  # When using the ViewModelTemplate, the FormView should be
  # completely initialized with the defaults (assuming that
  # the editors are supposed to be text fields.

  form = Views::FormView.new(template)
  form.signal_connect("form-submit") do |form, m|
    puts "Model: #{m.inspect}"
  end

  dialog :title=> "Test Form" do |dlg|
    dlg.add(form)
  end
end
