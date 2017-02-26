define profile::webserver::locations (
    $location_template_name,
    $location_overrides = {}
) {
    $templates = lookup($location_template_name, Hash, undef, {})
    $server_name = regsubst($name, '[\[\]]', '', 'G')
    $vhost_config = merge($location_overrides, { server => "$server_name" })
    create_resources('nginx::resource::location', $templates, $vhost_config)
}