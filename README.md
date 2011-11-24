
README for Ruby MVC
===================

This project is based on previous work on [Shoes
MVC](https://github.com/atownley/shoes_mvc), but now does not
use the Shoes toolkit.  At the moment, it achieves a minimal set of
cross-platform functionality based on using the wxRuby gem.  There are
plans to make this change in the future, but right now, the goal is
just to get something working.

*NOTE:  this code is **highly experimental** and an early work
in progress.  It may or may not ever be completed, and it may
or may not ever be useful.*

DEPENDENCIES
============

You'll need to have the following gems installed to use this library:

 - activerecord (to use the Rails integration)
 - tagz (for the HTML rendering)
 - wxruby (use wxruby-ruby19 for Ruby 1.9)
 - sqlite3 (to use the SQLite3 drivers)

Platform Notes
--------------

There are some tweaks required using the library with various
environments.  The known ones are highlighted below.

### Ruby 1.8.7

Apparently, there's a change in 1.8.7 that causes trouble with SWIG
libraries: http://www.ruby-forum.com/topic/161876.  You may or may not
hit this problem running 1.8.7, as it appears to be rather
intermittent.


### MacOS X

If you're using this on a 64-bit version of OSX, you'll want to make
sure you do the following when you're installing the dependency gems:

    $ env ARCHFLAGS="-arch x86_64 -arch i686" gem install --no-ri --no-rdoc

The above line will ensure that when you run in 32-bit mode for
wxRuby, that things will all work as expected.

Additionally, you might consider an alias like the following somewhere
handy like .profile or .bashrc

	alias wxruby="arch -i386 ruby -rubygems"

This link is also useful if using rvm and ruby 1.9.x:
http://www.ruby-forum.com/topic/212707#969982.  The magic is this
command:

	rvm install ruby-1.9.2 -C --with-arch=x86_64,i386

Once you do the above, you should be able to successfully install the
wxruby-ruby19 gem.

### Windows

Amazingly enough, it seems to *just work* on Windows (Vista is the
only tested configuration at the moment).  YMMV.
