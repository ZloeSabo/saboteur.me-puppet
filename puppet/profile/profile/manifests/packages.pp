class profile::packages inherits profile {
  $packages = lookup('profile::packages', Hash, undef, {})
  create_resources('package', $packages)
}
