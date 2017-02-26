class profile::webserver inherits profile {
  #Wordpress config
  # $wordpress_vhosts = hiera_hash('wordpress::vhosts')
  # $wordpress_vhost_keys = keys($wordpress_vhosts)

  # profile::webserver::vhost { "$wordpress_vhost_keys":
  #   vhost_config_list   => $wordpress_vhosts,
  #   vhost_template_name => 'wordpress::vhost::template'
  # }

  # profile::webserver::locations { $wordpress_vhost_keys:
  #   location_template_name => 'wordpress::location::template'
  # }

  # file { '/var/www':
  #   ensure => 'directory',
  # }

  # $enable_ssl = hiera('webserver_ssl')
  # if ($enable_ssl) {
  #   class { ::letsencrypt:
  #     config => {
  #         email  => hiera('webserver_ssl_email'),
  #         server => 'https://acme-v01.api.letsencrypt.org/directory',
  #     },
  #     manage_dependencies => false
  #   }
  # }
}
