##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "aws_route53_record" "cross_validation" {
  for_each = merge([
    for k in toset(local.domain_validated) : {
      for dvo in aws_acm_certificate.this[k].domain_validation_options : "${k}-${dvo.domain_name}" => {
        name  = dvo.resource_record_name
        value = dvo.resource_record_value
        type  = dvo.resource_record_type
      } if endswith(dvo.domain_name, var.dns_zone_domain) == true && var.external_dns_zone == false && var.cross_account
    }
  ]...)
  provider        = aws.cross_account
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.value]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.cross_zone[0].id
}

resource "aws_acm_certificate_validation" "cross" {
  for_each        = toset(local.domain_validated)
  certificate_arn = aws_acm_certificate.this[each.key].arn
  validation_record_fqdns = [
    for dvo in aws_acm_certificate.this[each.key].domain_validation_options :
    dvo.resource_record_name
  ]

  timeouts {
    create = "60m"
  }
}

