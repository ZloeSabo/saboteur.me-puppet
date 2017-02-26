define profile::applications::wordpress (
    $www_root,
    #TODO check how to pass it in the right way
    $www_user = $::profile::www_user,
    $www_group = $::profile::www_group,
    $db_name,
    $db_user,
    $db_password,
    $db_host = 'localhost',
    $server_template_name = 'wordpress::server_template',
    $location_template_name = 'wordpress::location_template',
    $ssl = false,
    $ssl_email = '',
) {
    $domain = regsubst($name, '[\[\]]', '', 'G')

    #1. create database
    create_resources('profile::db::instance', {
        $domain => {
            "database" => $db_name,
            "user"     => $db_user,
            "password" => $db_password
        }
    })

    #2. create wp instance
    create_resources('wordpress::instance', { 
        $www_root => {
            version        => 'latest',
            create_db      => false,
            create_db_user => false,
            db_name        => $db_name,
            db_user        => $db_user,
            db_host        => $db_host,
            db_password    => $db_password,
            wp_owner       => $www_user,
            wp_group       => $www_group
        }
    })

    #prepare certificates if required
    if $ssl {
        include ::webcerts
        webcerts::cert {"SSL cert ${domain}":
            domain   => $domain,
            email    => $ssl_email,
            www_root => $www_root,
        }
        #todo verify ssl email
        $vhost_config = {
            "ssl"          => true,
            "ssl_cert"     => "/etc/letsencrypt/live/${domain}/cert.pem",
            "ssl_key"      => "/etc/letsencrypt/live/${domain}/privkey.pem",
            #TODO add certificate chain
            "ssl_redirect" => true,
            "www_root"     => $www_root
        }
        $location_overrides = {
            "ssl"      => true,
            "ssl_only" => true
        }
        #notify                      => Class['nginx::service'],
    } else {
        $vhost_config = {
            "www_root" => $www_root,
        }
        $location_overrides = {
            "ssl"      => false
        }
    }

    #3. create webserver entries
    create_resources('profile::webserver::server', {
        $domain => {
            "vhost_config"        => $vhost_config,
            "vhost_template_name" => $server_template_name
        }
    })

    create_resources('profile::webserver::locations', {
        $domain => {
            "location_template_name" => $location_template_name,
            "location_overrides"     => $location_overrides
        }
    })

    # Make sure web directory actually exists
    # create_resources('file', {
    #     '/var/www' => {
    #     ensure => 'directory'
    #     }
    # })
    # file {'/var/www':
    #     ensure => 'directory'
    # }

    # Class['profile::db::instance'] -> Class['wordpress::instance']
}