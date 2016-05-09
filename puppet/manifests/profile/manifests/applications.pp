class profile::applications inherits profile {
  #Wordpress instances
  define profile::applications::wordpress($vhosts, $databases) {
    $www_root = $vhosts[$name][www_root]
    $database_info = $databases[$name]

    $config = { "$www_root" => {
      version        => 'latest',
      create_db      => false,
      create_db_user => false,
      db_name        => $database_info[database],
      db_user        => $database_info[user],
      db_host        => 'localhost',
      db_password    => $database_info[password],
    }}

    create_resources('wordpress::instance', $config)
  }

  $wordpress_vhosts = hiera_hash('wordpress::vhosts')
  $databases = hiera_hash('databases')

  $wordpress_keys = keys($wordpress_vhosts)

  profile::applications::wordpress {$wordpress_keys:
    vhosts    => $wordpress_vhosts,
    databases => $databases
  }
}
