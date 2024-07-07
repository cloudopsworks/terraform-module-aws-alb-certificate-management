##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  domain_validated = [
    for k, v in var.certificates : k
    if try(v.validation_method, "DNS") == "DNS"
  ]
}

data "aws_route53_zone" "cert_zone" {
  name         = var.dns_zone_domain != "" ? var.dns_zone_domain : null
  private_zone = var.dns_zone_domain != "" ? var.private_dns_zone : null
  zone_id      = var.dns_zone_id != "" ? var.dns_zone_id : null
}

resource "aws_acm_certificate" "this" {
  for_each                  = var.certificates
  domain_name               = each.value.domain_name
  validation_method         = try(each.value.validation_method, "DNS")
  subject_alternative_names = try(each.value.subject_alternative_names, [])
  key_algorithm             = try(each.value.key_algorithm, "RSA_2048")
  dynamic "options" {
    for_each = try(each.value.options, [])
    content {
      certificate_transparency_logging_preference = options.value.certificate_transparency_logging_preference ? "ENABLE" : "DISABLE"
    }
  }
  dynamic "validation_option" {
    for_each = try(each.value.validation_option, [])
    content {
      domain_name       = validation_option.value.domain_name
      validation_domain = validation_option.value.validation_domain
    }
  }

  tags = merge(
    local.all_tags,
    try(each.value.tags, {})
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = merge([
    for k in toset(local.domain_validated) : {
      for dvo in aws_acm_certificate.this[k].domain_validation_options : "${k}-${dvo.domain_name}" => {
        name  = dvo.resource_record_name
        value = dvo.resource_record_value
        type  = dvo.resource_record_type
      } if endswith(dvo.domain_name, var.dns_zone_domain) == true
    }
  ]...)
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.value]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.cert_zone.id
}

resource "aws_acm_certificate_validation" "this" {
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

resource "aws_lb_listener_certificate" "this" {
  for_each        = var.certificates
  certificate_arn = aws_acm_certificate_validation.this[each.key].certificate_arn
  listener_arn    = try(each.value.listener_arn, var.load_balancer_listener_arn)
}