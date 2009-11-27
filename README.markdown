rubygems-gui
============

This is a Sinatra application to manage gems more conveniently than from the command line, since there are some things that the command line makes
unnecessarily complicated.

I'm using Synaptic Package Manager as a role model.

Installing
==========
You need to allow the user that runs the app to run `sudo gem` without a password prompt. Do do this, run `sudo visudo` and add the following line to
the *bottom* of the file:

  username ALL=(root) NOPASSWD:/opt/ruby-enterprise/bin/gem

(tweak it for your system)

Then, `gem install sinatra haml`

Then, `sinatra rubygems-gui.rb`

That's all.

Features
========
* browsing a list of gems with descriptions and homepage links
* cleaning up of outdated gems
* uninstallation of gems

TODO
====
* production-ready version
* configuration options


