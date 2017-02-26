class profile::db inherits profile {
  # include profile::db::instance
  # $server_name = regsubst($name, '[\[\]]', '', 'G')
  # $databases = hiera_hash('databases')
  # # create_resources('profile::db::instance', $databases)
  # $databases.each |String $server_name, Hash $settings| {
  #   profile::db::instance {$server_name:
  #     database => $settings[database],
  #     user     => $settings[user],
  #     password => $settings[password]
  #   }
  # }

  # profile::db::instance { $databases: }
}
