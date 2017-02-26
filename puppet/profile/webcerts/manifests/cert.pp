define webcerts::cert(
    $email,
    $domain,
    $www_root,
    $use_fake = $webcerts::use_fake
) {
    if $use_fake {
        webcerts::fake_cert {$domain:
            domain => $domain
        }
    } else {
        fail('Not implemented')
    }
}