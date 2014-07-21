# Based on example code from https://github.com/jfryman/puppet-nginx
define site::roles::website (
  $backend_port         = 9000,
  $php                  = true,
  $proxy                = undef,
  $www_root             = "${full_web_path}/${name}/",
  $location_cfg_append  = undef,
) {
  nginx::resource::vhost { "${name}":
    ensure              => present,
    www_root            => "${full_web_path}/${name}/",
    location_cfg_append => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
  }

  if !$www_root {
    $tmp_www_root = undef
  } else {
    $tmp_www_root = $www_root
  }

#  nginx::resource::vhost { $name:
#    ensure                => present,
#    listen_port           => 80,
#    www_root              => $tmp_www_root,
#    proxy                 => $proxy,
#    location_cfg_append   => $location_cfg_append,
#    index_files           => [ 'index.php' ],
#  }


  if $php {
    nginx::resource::location { "${name}_root":
      ensure          => present,
      ssl             => true,
      ssl_only        => true,
      vhost           => $name,
      www_root        => "${full_web_path}/${name}/",
      location        => '~ \.php$',
      index_files     => ['index.php', 'index.html', 'index.htm'],
      proxy           => undef,
      fastcgi         => "127.0.0.1:${backend_port}",
      fastcgi_script  => undef,
      location_cfg_append => {
        fastcgi_connect_timeout => '3m',
        fastcgi_read_timeout    => '3m',
        fastcgi_send_timeout    => '3m'
      }
    }
  }
}
