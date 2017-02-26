class webcerts(
    $use_fake = false
) {
    file { ["/etc/letsencrypt", "/etc/letsencrypt/live/"]:
        ensure  => 'directory',
        recurse => true
    }
}