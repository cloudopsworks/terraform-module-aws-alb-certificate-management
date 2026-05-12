##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "certificates" {
  description = "Map of ACM certificate details keyed by certificate resource ID."
  value = {
    for cert in aws_acm_certificate.this : cert.id => {
      id                        = cert.id
      arn                       = cert.arn
      domain_name               = cert.domain_name
      status                    = cert.status
      subject_alternative_names = cert.subject_alternative_names
      key_algorithm             = cert.key_algorithm
      not_after                 = cert.not_after
      not_before                = cert.not_before
      pending_renewal           = cert.pending_renewal
      renewal_eligibility       = cert.renewal_eligibility
      renewal_summary           = cert.renewal_summary
      type                      = cert.type
    }
  }
}

output "listener_certificates" {
  description = "Map of ALB listener certificate associations keyed by resource ID."
  value = {
    for cert in aws_lb_listener_certificate.this : cert.id => {
      id              = cert.id
      certificate_arn = cert.certificate_arn
      listener_arn    = cert.listener_arn
    }
  }
}
