class profile::common inherits profile {
  $root_password = 'thisissosecret'
  $fpm_upstream = 'phpfpm'

  ufw::allow {'ssh':
    port => 22,
    ip   => 'any'
  }
  ufw::allow {'http':
    port => 80,
    ip   => 'any'
  }
  ufw::allow {'https':
    port => 443,
    ip   => 'any'
  }
}
