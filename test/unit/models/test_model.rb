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
# File:     test_model.rb
# Created:  Sat 31 Dec 2011 16:07:07 CET
#
######################################################################
#++

$:.unshift File.join(File.dirname(__FILE__), "../../../lib")

require 'testy'
require 'ruby_mvc'

include RubyMVC::Models

Testy.testing "Core Model tests" do
  test "Basic functionality" do |result|
    model = Model.new
    model[:key1] = "val1"
    model[:key2] = "val2"

    result.check "keys are correct",
        :expect => [ :key1, :key2 ],
        :actual => model.keys.sort
   
    result.check "labels are correct",
        :expect => [ { :key => :key1, :label => "Key1" }, { :key => :key2, :label => "Key2" } ],
        :actual => model.labels

    result.check ":key1 is editable",
        :expect => true,
        :actual => model.is_editable?(:key1)
    
    result.check ":key2 is editable",
        :expect => true,
        :actual => model.is_editable?(:key2)

    result.check "#[] accessor",
        :expect => "val1",
        :actual => model[:key1]

    result.check "#size accessor",
        :expect => 2,
        :actual => model.size

    result.check "#label_for :key1",
        :expect => "Key1",
        :actual => model.label_for(:key1)

    result.check "#label_for :key2",
        :expect => "Key2",
        :actual => model.label_for(:key2)
  end
  
  test "Signal tests" do |result|
    model = Model.new

    event = {}
    model.signal_connect("property-changed") do |m, k, o, v|
      event[:model] = m
      event[:key] = k
      event[:old] = o
      event[:value] = v
    end 
    model[:key1] = "val1"
    
    result.check "signal emit",
        :expect => { :model => model, :key => :key1, :old => nil, :value => "val1" },
        :actual => event
  end
end
