admins = { "admin@dlp.local" }

modules_enabled = {
    "roster";
    "saslauth";
    "dialback";
    "disco";
    "ping";
    "register";
    "vcard";
}

allow_registration = true

daemonize = false
pidfile = "/var/run/prosody/prosody.pid"

c2s_require_encryption = false
s2s_require_encryption = false

log = {
    { levels = { min = "info" }, to = "console" };
}

VirtualHost "dlp.local"
    enabled = true
