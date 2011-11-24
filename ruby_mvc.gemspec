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
# File:     ruby_mvc.gemspec
# Created:  Sat 19 Nov 2011 11:45:06 GMT
#
######################################################################
#++

require 'rake'

Gem::Specification.new do |s|
  s.name        = "ruby_mvc"
  s.version     = "0.0.0"
  s.summary     = "Ruby MVC"
  s.description = "A simple, cross-platform MVC framework for Ruby"
  s.authors     = [ "Andrew S. Townley" ]
  s.email       = "ast@atownley.org"
  s.files       = FileList['lib/**/*.rb', 'sample/**/*', 'test/**/*', '[A-Z]*', 'ruby_mvc.gemspec'].to_a
  s.homepage    = "https://github.com/atownley/ruby_mvc"
end
