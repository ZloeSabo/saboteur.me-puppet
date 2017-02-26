class profile::applications inherits profile {
  file {'/var/www':
      ensure => 'directory'
  }
  #Wordpress instances
  $wordpress_vhosts = lookup('applications::wordpress', Hash, undef, {})
  create_resources('profile::applications::wordpress', $wordpress_vhosts)

}
