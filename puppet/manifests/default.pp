hiera_include('classes')

node default {
  include profile::common
  include profile::packages
  include profile::applications

  include '::php'

  Class['apt::update'] -> Package <| provider == 'apt' |>
  Class['apt::update'] -> Class['mysql::server']
  Class['apt::update'] -> Class['mysql::client']
  Exec['apt_update'] -> Package['nginx']
}
