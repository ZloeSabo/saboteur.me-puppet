define webcerts::fake_cert(
    $domain,
    $directory = "/etc/letsencrypt/live/${domain}"
) {
    $prefix = "/etc/letsencrypt/live/${domain}"
    $key = "${prefix}/privkey.pem"
    $crt = "${prefix}/cert.pem"
    $chain = "${prefix}/fullchain.pem"

    file { "/etc/letsencrypt/live/${domain}":
        ensure  => 'directory',
        recurse => true
    }

    exec { "Generate fake cert ${domain}":
        command => "openssl req -x509 -nodes -newkey rsa:2048 -keyout ${key} -out ${crt} -subj \"/C=DE/ST=Test/L=Test/O=Test Network/OU=IT Department/CN=${domain}\"",
        creates => $key,
        path    => ['/usr/bin'],
        require => File[$directory]
    }
    exec { "Generate fake chain ${domain}":
        command => "touch ${chain}",
        creates => $chain,
        path    => ['/usr/bin'],
        require => File[$directory]
    }
}