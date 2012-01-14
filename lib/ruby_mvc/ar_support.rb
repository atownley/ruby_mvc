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
# File:     ar_support.rb
# Created:  Mon 12 Dec 2011 06:49:00 CST
#
#####################################################################
#++ 

require 'active_record'

require 'ruby_mvc/models/ar_row_model'
require 'ruby_mvc/models/ar_table_model'
require 'ruby_mvc/views/ar_form_view'
require 'ruby_mvc/views/ar_type_editor'
require 'ruby_mvc/views/ar_web_type_list'
require 'ruby_mvc/views/ar_web_model_view'

module RubyMVC

  class ActiveRecordModelRegistry < Hash
    def model(etk, options = {})
      key = etk
      key = etk.to_s.to_sym if !etk.is_a? Symbol
      if has_key? key
        self[key]
      else
        self[key] = Models::ActiveRecordTableModel.new(etk, options)
      end
    end
  end

  def self.model(*args, &block)
    @ar_models ||= ActiveRecordModelRegistry.new
    @ar_models.model(etk, options)
  end

  class ActiveRecordTemplateRegistry < Hash
    def template(etk, title = nil, options = {}, &block)
      if title.is_a? Hash
        options = title
        title = options[:title]
      end
      key = etk
      key = etk.to_s.to_sym if !etk.is_a? Symbol
      if block
        obj = Models::ViewModelTemplate.new(options, &block)
        obj.title = title || etk.to_s
        self[key] = obj
      else
        self[key]
      end
    end
  end

  def self.template(*args, &block)
    @ar_templates ||= ActiveRecordTemplateRegistry.new
    @ar_templates.template(*args, &block)
  end

  def template(*args, &block)
    RubyMVC.template(*args, &block)
  end

  def model(*args, &block)
    RubyMVC.model(*args, &block)
  end
end
