Docker / Puppet Apache Example
=============================

##Description
This repository implements a basic Docker and puppet-based Apache/PHP setup with an example Drupal 7 site included in www.

This is intended as the starting point for your own site-specific Dockerfile.

##Usage
To develop / experiment with the puppet configuration, start it in vagrant with `vagrant up`. This will provide a nice interactive
environment.

No puppet server is needed - the module is designed to run in standalone puppet
with no exported resources. This module expects configuration data to be
configured via hiera yaml files in the hieradata folder.
