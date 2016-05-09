hiera_include('classes')

node default {
  include profile::common
  include profile::packages
  include profile::webserver
  include profile::db
  include profile::applications

  Class['apt::update'] -> Package <| provider == 'apt' |>
  Class['apt::update'] -> Class['mysql::server']
  Class['apt::update'] -> Class['mysql::client']

}
