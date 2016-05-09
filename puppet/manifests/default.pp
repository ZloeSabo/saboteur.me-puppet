hiera_include('classes')

node default {
  $server_host = 'dev.saboteur.vm'
  $full_web_path = "/var/www/${server_host}"
  $fpm_upstream = 'phpfpm'

  $wp_user = 'wpuser'
  $wp_password = 'wppass'
  $wp_database = 'wpdatabase'

  include profile::common
  include profile::packages
  include profile::webserver

  # mysql_plugin { 'auth_socket':
  #   ensure     => 'present',
  #   soname     => 'auth_socket.so',
  # }

  mysql::db { $wp_database:
    user     => $wp_user,
    password => $wp_password,
    host     => 'localhost',
    grant    => ['ALL'],
  }

  #WP stuff

  # nginx::resource::vhost { $server_host:
  #   ensure                => present,
  #   www_root              => $full_web_path,
  #   index_files           => [ 'index.php' ],
  #   try_files             => [ '$uri', '$uri/', '/index.php?$args'],
  #   location_cfg_append => {
  #     'rewrite' => '/wp-admin$ $scheme://$host$uri/ permanent'
  #   },
  # }
  #
  # nginx::resource::location { "${server_host}_root":
  #   ensure          => present,
  #   vhost           => $server_host,
  #   www_root        => $full_web_path,
  #   try_files       => [ '$uri', '=404'],
  #   location        => '~ \.php$',
  #   # index_files     => ['index.php', 'index.html', 'index.htm'],
  #   # proxy           => 'http://phpfpm',
  #   fastcgi         => $fpm_upstream,
  #   fastcgi_script  => undef,
  #   location_cfg_append => {
  #     fastcgi_connect_timeout => '3m',
  #     fastcgi_read_timeout    => '3m',
  #     fastcgi_send_timeout    => '3m'
  #   }
  # }
  #
  # nginx::resource::location { "${server_host}_static":
  #   vhost               => $server_host,
  #   #location_alias      => '/aa',
  #   #www_root            => $full_web_path,
  #   location            => '~* ^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|rss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$',
  #   location_custom_cfg => {
  #     'access_log'    => 'off',
  #     'log_not_found' => 'off',
  #     'expires'       => 'max'
  #   }
  # }
  #
  # nginx::resource::location { "${server_host}_favicon":
  #   vhost               => $server_host,
  #   location            => '/favicon.ico',
  #   location_custom_cfg => {
  #     'access_log'    => 'off',
  #     'log_not_found' => 'off',
  #   }
  # }
  #
  # nginx::resource::location { "${server_host}_robots":
  #   vhost               => $server_host,
  #   location            => '/robots.txt',
  #   try_files           => [ '$uri', '/index.php?$args'],
  #   location_custom_cfg => {
  #     'access_log'    => 'off',
  #     'log_not_found' => 'off',
  #     'allow'         => 'all'
  #   }
  # }
  #
  # nginx::resource::location { "${server_host}_dotdirs":
  #   vhost               => $server_host,
  #   location            => '~ /\.',
  #   location_custom_cfg => {
  #     'deny'         => 'all'
  #   }
  # }
  #
  # nginx::resource::location { "${server_host}_scripts_in_uploads":
  #   vhost               => $server_host,
  #   location            => '~* /(?:uploads|files)/.*\.php$',
  #   location_custom_cfg => {
  #     'deny'         => 'all'
  #   }
  # }

  class { '::wordpress':
    version     => 'latest',
    create_db   => false,
    create_db_user => false,
    install_dir => $full_web_path,
    db_name     => $wp_database,
    db_user     => $wp_user,
    db_host     => 'localhost',
    db_password => $wp_password,
  }

  Class['apt::update'] -> Package <| provider == 'apt' |>
  Class['apt::update'] -> Class['mysql::server']
  Class['apt::update'] -> Class['mysql::client']

  # file { '/etc/nginx/global/restrictions.conf':
  #   ensure => file,
  #   mode => '0644',
  #   owner  => 'root',
  #   group  => 'root',
  #   source => 'puppet:///files/nginx/restrictions.conf'
  # }

  #
  #
  # include '::php'
  # include '::ntp'
}
