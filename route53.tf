##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

data "aws_route53_zone" "cert_zone" {
  count        = var.cross_account == false && var.external_dns_zone == false ? 1 : 0
  name         = var.dns_zone_domain != "" ? var.dns_zone_domain : null
  private_zone = var.dns_zone_domain != "" ? var.private_dns_zone : null
  zone_id      = var.dns_zone_id != "" ? var.dns_zone_id : null
}

data "aws_route53_zone" "cross_zone" {
  count        = var.cross_account == true && var.external_dns_zone == false ? 1 : 0
  provider     = aws.cross_account
  name         = var.dns_zone_domain != "" ? var.dns_zone_domain : null
  private_zone = var.dns_zone_domain != "" ? var.private_dns_zone : null
  zone_id      = var.dns_zone_id != "" ? var.dns_zone_id : null
}
