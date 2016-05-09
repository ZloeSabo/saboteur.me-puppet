class profile::db inherits profile {
  define profile::db::instance ($database, $user, $password) {
    $db_config = {"$database" => {
      'user'     => $user,
      'password' => $password,
      'host'     => 'localhost',
      'grant'    => ['ALL'],
    }}
    create_resources('mysql::db', $db_config)
  }

  $databases = hiera_hash('databases')
  create_resources('profile::db::instance', $databases)
}
