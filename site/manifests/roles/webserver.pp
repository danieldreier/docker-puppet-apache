# Everything needed to set up a base webserver
# Wraps apache module
class site::roles::webserver (
  $vhosts = {},
  ) {
  anchor { '::site::roles::webserver': }
  Class {
    require => Anchor['::site::roles::webserver'],
  }
  class { 'apache':
    default_mods        => false,
    default_confd_files => false,
    mpm_module          => 'prefork',
    default_vhost       => false,
    service_name        => 'apache2',
  }

  include apache::mod::rewrite
  include apache::mod::deflate
  include apache::mod::status
  include apache::mod::ssl

  class { '::site::roles::webserver::php': }
  file { [ '/var/www', '/var/www/vhosts' ]:
    ensure => 'directory',
  }
  create_resources('apache::vhost', $vhosts)
}


