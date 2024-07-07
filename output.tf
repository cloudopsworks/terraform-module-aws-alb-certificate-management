##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "certificates" {
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
      status                    = cert.status
      type                      = cert.type
    }
  }
}