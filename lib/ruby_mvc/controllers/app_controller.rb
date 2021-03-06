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
# File:     app_controller.rb
# Created:  Sat 19 Nov 2011 11:29:49 GMT
#
#####################################################################
#++ 

module RubyMVC

  # This module takes care of dispatching links to controller
  # classes.

  module LinkDispatcher
    # This method is a callback to allow links embedded in
    # views to trigger controller actions in a loosely-coupled
    # manner.
    #
    # The default implementation will attempt to call methods
    # based on applying the RubyMVC#method_name
    # transformation and checking if the controller responds
    # to the method.  To manually dispatch the method, simply
    # override this method in the derived class.

    def link_activated(sender, link)
      puts "#link_activated(#{sender}, #{link})"
      uri = URI.parse(link)
      
      if uri.query
        params = CGI.parse(uri.query)
        params.each do |k, v|
          if v && v.size == 1
            params[k] = v.first
          end
        end
      end

      m = RubyMVC.method_name(uri.path).to_sym
      if self.respond_to? m
        self.send(m, sender, link, params)
      end
    end
  end

  class AppController
    include LinkDispatcher

    attr_accessor :app

    # By convention, the application is configured using an
    # app.yml file in the same directory as the application
    # controller.

    def initialize(app_file)
      @config_file = File.expand_path(File.join(File.dirname(app_file), "../app.yml"))
      if !File.exist? @config_file
        @shoes.alert("Unable to locate configuration file.\nFile '#{@config_file}' not found.")
        @shoes.exit
      end

      @config = YAML.load(File.new(@config_file))
      setup
      run
    end

    # This method is a placeholder for the actual
    # initialization to be performed by the Ruby application
    # itself.  It is called automatically by the constructor
    # of the application controller.

    def run
    end

  protected
    def config
      @config || {}
    end

    # This method is called prior to calling the #run method
    # to give the derived controller classes an opportunity to
    # perform any specific initialization.

    def setup
    end
  end

end
