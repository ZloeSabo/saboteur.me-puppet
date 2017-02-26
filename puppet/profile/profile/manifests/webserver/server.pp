define profile::webserver::server (
    $vhost_config,
    $vhost_template_name = ''
) {
    $server_name = regsubst($name, '[\[\]]', '', 'G')
    $template = lookup($vhost_template_name, Hash, undef, {})
    $vhost_config_resource = { "$server_name" => $vhost_config }
 
    create_resources('nginx::resource::server', $vhost_config_resource, $template)

    # if (hiera('webserver_ssl')) {
    #     # notice($vhost_config_list[$server_name])

    #     letsencrypt::certonly { $server_name:
    #         domains       => [$server_name],
    #         plugin        => 'webroot',
    #         webroot_paths => [$vhost_config_list[$server_name][www_root]],
    #     }
    # }
}