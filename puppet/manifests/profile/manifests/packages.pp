class profile::packages inherits profile {
  $packages = hiera_hash('profile::packages', {})
  create_resources(package, $packages)
}
