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
# File:     form.rb
# Created:  Fri 30 Dec 2011 16:08:40 CET
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

  # In this case, the FormView specifies the editors for the
  # model properties, but the properties will always be
  # displayed in the order in which they are defined in the
  # model.  If more control is desired, then a
  # ViewModelTemplate instance should be used to provide the
  # desired ordering.

  form = Views::FormView.new(model) do
    disabled :id
    editor :lname, :textfield
    editor :fname, :textfield
    editor :description, :textarea
  end
  form.signal_connect("form-submit") do |form, m|
    puts "Model: #{m.inspect}"
  end

  dialog :title=> "Test Form" do |dlg|
    dlg.add(form)
  end
end
