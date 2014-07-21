# Configure hiera
# this is in a separate class so that it can be run during provisioning
# prior to the first full puppet run
class site::roles::base::hiera::install {
  class { 'hiera':
    hierarchy => [
      'etcddata',
      'website',
      'defaults',
    ],
    datadir   => '/etc/puppet/hieradata',
  }
}
