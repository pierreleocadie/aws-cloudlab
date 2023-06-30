resource "aws_route53_zone" "deletesystem32_fr" {
    name = "deletesystem32.fr"
}

resource "aws_route53_record" "deletesystem32" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "nginx_reverse_proxy_manager" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "proxymanager.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "goaccess" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "goaccess.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "wireguard" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "wireguard.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "admin_wireguard" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "admin.wireguard.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "phpmyadmin" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "phpmyadmin.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "mongodb" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "mongodb.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "mongodbexpress" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "mongodbexpress.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "portainer" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "portainer.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "dns" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "dns.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "edt" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "edt.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "api_coutryguesser" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "api.countryguesser.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "ws_countryguesser" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "ws.countryguesser.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}

resource "aws_route53_record" "api_applicationsondage" {
    zone_id = aws_route53_zone.deletesystem32_fr.zone_id
    name = "api.applicationsondage.deletesystem32.fr"
    type = "A"
    ttl = "300"
    records = ["${aws_instance.cloudlab_public_facing_entrypoint.public_ip}"]
}


output "deletesystem32_fr_ns" {
    value = aws_route53_zone.deletesystem32_fr.name_servers
}
