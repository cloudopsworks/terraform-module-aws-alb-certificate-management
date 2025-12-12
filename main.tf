##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  domain_validated = [
    for k, v in var.certificates : k
    if try(v.validation_method, "DNS") == "DNS"
  ]
}

resource "aws_acm_certificate" "this" {
  for_each                  = var.certificates
  domain_name               = each.value.domain_name
  validation_method         = try(each.value.validation_method, "DNS")
  subject_alternative_names = try(each.value.subject_alternative_names, [])
  key_algorithm             = try(each.value.key_algorithm, "RSA_2048")
  dynamic "options" {
    for_each = length(try(each.value.options, {})) > 0 ? [1] : []
    content {
      certificate_transparency_logging_preference = try(each.value.options.certificate_transparency_logging_preference, null) != null ? (
        each.value.options.certificate_transparency_logging_preference ? "ENABLE" : "DISABLE"
      ) : null
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
    try(each.value.tags, {}),
    {
      Name = "${each.key}-${local.system_name}"
    }
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_certificate" "this" {
  for_each        = var.certificates
  certificate_arn = aws_acm_certificate_validation.this[each.key].certificate_arn
  listener_arn    = try(each.value.listener_arn, data.aws_lb_listener.listener[each.key].arn, data.aws_lb_listener.this[0].arn, var.load_balancer_listener_arn)
}

data "aws_lb" "this" {
  count = var.lb_arn != "" ? 1 : 0
  arn   = var.lb_arn
}

data "aws_lb_listener" "this" {
  count             = var.load_balancer_listener_port != -1 && var.lb_arn != "" ? 1 : 0
  load_balancer_arn = data.aws_lb.this[0].arn
  port              = var.load_balancer_listener_port
}

data "aws_lb_listener" "listener" {
  for_each = {
    for id, cert in var.certificates : id => cert
    if try(cert.listener_port, -1) != -1
  }
  load_balancer_arn = data.aws_lb.this[0].arn
  port              = each.value.listener_port
}