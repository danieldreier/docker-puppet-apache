# Everything needed to set up a base webserver
# Wraps nginx module, adds firewall
class site::roles::php {
  class { '::phpfpm':
    poold_purge => true,
  }

  # TCP pool using 127.0.0.1, port 9000, upstream defaults
  phpfpm::pool { 'main':
    chroot => '/var/www',
  }
}
