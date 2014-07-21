# Bootstrap r10k
package { 'rubygems': ensure => 'installed' }
package { 'r10k':
  ensure   => 'installed',
  provider => 'gem',
  require  => Package['rubygems'],
}
file { '/etc/puppet/manifests/site.pp':
  mode    => '0644',
  content => 'hiera_include("classes")',
}

# set modulepath so that r10k does not wipe out site module
augeas { 'modulepath':
  context => '/etc/puppet/puppet.conf',
  changes => [
    "set /files/etc/puppet/puppet.conf/main/modulepath '\$confdir/modules:\$confdir/local'"
  ],
}

# Unset templatedir to suppress annoying deprecation warnings
augeas { 'unset_templatedir':
  context => '/etc/puppet/puppet.conf',
  changes => [
    'rm /files/etc/puppet/puppet.conf/main/templatedir',
  ],
}


# Run librarian-puppet only if Puppetfile changed
exec { 'run r10k':
  environment => ['HOME=/root'],
  timeout     => '900',
  command     => 'r10k puppetfile install',
  cwd         => '/etc/puppet',
  path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  require     => Package['r10k'],
}
