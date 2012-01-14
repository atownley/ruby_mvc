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
# File:     ar_web_model_view.rb
# Created:  Mon  9 Jan 2012 22:45:05 GMT
#
#####################################################################
#++ 

module RubyMVC
module Views

  class ActiveRecordWebModelView < WebModelView
    signal "add-child"
    signal "add-child-link"
    signal "row-edit"
    signal "row-delete", :vetoable => true

    # This signal is triggered when the view needs to render
    # an action link for one of the linked models.  Currently
    # supported command keys are:
    #
    # - :link_edit - return a hash with the href to edit the
    #               link entries
    #
    # In each case, the arguments sent are the view, the
    # command key, the model and the label entry being
    # rendered.

    signal "action-link"

    def initialize(row, options = {})
      super

      action(:edit, :label => "Edit", :icon => :stock_edit) do
        signal_emit("row-edit", self, row)
      end

#      action(:delete, :label => "Delete", :icon => :stock_delete) do
#        signal_emit("row-delete", self, row)
#      end

      begin
        if @model.children
          action(:add_child, :label => "Add Child", :icon => :stock_new) do
            signal_emit("add-child", self, row)
          end

          action(:add_child_link, :label => "Add Child Link", :icon => :stock_new) do
            signal_emit("add-child-link", self, row)
          end
        end
      rescue NoMethodError
        # we ignore this on purpose
      end
    end

    def render
      # FIXME: this isn't the way to properly test for
      # ancestry, but we need it right now.  Needs to have a
      # review/revisit of the way things are nested.  It's
      # evolving a little organically at the moment
      # (2012-01-12: ast)

      tagz {
        render_parent
        super
        render_links
      }
    end

  protected
    def render_parent
      # FIXME: this is really screwed up and shouldn't really
      # work this way
#      puts "#render_ancestry"
      begin
        @model.reload
        kidz = @model.subtree[1..-1]
#        puts "Ancestors: " <<  kidz.inspect
        tagz {
          if cmd = signal_emit("action-link", self, :parent_edit, @model, {})
            cmd2 = signal_emit("action-link", self, :unparent, @model, {})
            h3_("Parent ") {
              font_(:size => "2") {
                a_ cmd.delete(:text), cmd
                tagz.push " "
                a_ cmd2.delete(:text), cmd2 if cmd2
              }
            }
          end
          if parent = @model.parent
#            puts "parent: #{parent.inspect}"
            et = parent.class
            pm = Models::ActiveRecordTableModel.new(et, :rows => [ parent ])
            if tmpl = RubyMVC.template(et)
              pm = tmpl.apply(pm)
            end
            tagz.push WebContentTableView.new(pm).render
          end
        }
      rescue NoMethodError => e 
        puts "warning: #{e}"
#        puts e.backtrace
      end
    end

    def render_links
#      puts "#render_links"

      tagz {
        # render children first
        render_children

        return if @model.link_labels.size == 0

        # render other links
        @model.link_labels.each do |l|
          links = @model.send(l[:key], true)
          edits = []
          cmds = [ :linked_edit ]
          if l.has_key? :link_entity
            cmds.insert(0, :add_link)
            cmds.insert(0, :add_linked)
            cmds << :link_edit
          end

          cmds.each do |cmd|
            edits << signal_emit("action-link", self, cmd, @model, l)
          end
          let = l[:entity_type]
          h3_("#{let} links (#{links.size})") {
            if edits.size > 0
              font_(:size => "2") {
                edits.each do |cmd|
                  tagz.push " "
                  a_ cmd.delete(:text), cmd
                end
              }
            end
          }
          if links.size > 0
            lm = Models::ActiveRecordTableModel.new(let, :rows => links)
            if tmpl = RubyMVC.template(let)
              lm = tmpl.apply(lm)
            end
            tagz.push WebContentTableView.new(lm).render
          end
        end
      }
    end

    def render_children
      begin
#        puts "MODEL HAS CHILDREN? #{@model.has_children?}: #{@model.inspect}"
        if @model.has_children?
          kidz = @model.children
#          puts "Children: " << kidz.inspect
          et = kidz.first.class
          km = Models::ActiveRecordTableModel.new(et, :rows => kidz)
          if tmpl = RubyMVC.template(et)
            km = tmpl.apply(km)
          end
          tagz {
            h3_("Child #{et.to_s.pluralize}")
            tagz.push WebContentTableView.new(km).render
          }
        end
      rescue NoMethodError => e 
        puts "warning: #{e}"
#        puts e.backtrace
      end
    end
  end

end
end
