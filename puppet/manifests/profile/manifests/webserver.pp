class profile::webserver inherits profile {
  define profile::webserver::vhost ($vhost_config_list, $vhost_template_name) {
    $template = hiera($vhost_template_name)
    $vhost_config = { "$name" => $vhost_config_list[$name] }
    create_resources('nginx::resource::vhost', $vhost_config, $template)
  }
  define profile::webserver::locations ($location_template_name) {
    $templates = hiera($location_template_name)
    $vhost_config = { vhost => "$name" }
    create_resources('nginx::resource::location', $templates, $vhost_config)
  }

  #Wordpress config
  $wordpress_vhosts = hiera('wordpress::vhosts')
  $wordpress_vhost_keys = keys($wordpress_vhosts)

  profile::webserver::vhost { $wordpress_vhost_keys:
    vhost_config_list   => $wordpress_vhosts,
    vhost_template_name => 'wordpress::vhost::template'
  }

  profile::webserver::locations { $wordpress_vhost_keys:
    location_template_name => 'wordpress::location::template'
  }

  file { '/var/www':
    ensure => 'directory',
  }
}
