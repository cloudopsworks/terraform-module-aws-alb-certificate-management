##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "dns_zone_domain" {
  description = "The DNS zone domain, used if zone_id is not provided."
  type        = string
  default     = ""
}

variable "dns_zone_id" {
  description = "The DNS zone to use for the DNS records, must be provided if dns_zone_domain is not provided."
  type        = string
  default     = ""
}

variable "private_dns_zone" {
  description = "If true, the DNS zone to search is private."
  type        = bool
  default     = false
}

variable "external_dns_zone" {
  description = "If true, the DNS zone is external and assumed no local Route53 validation required."
  type        = bool
  default     = false
}

## certificates configuration - YAML format
# certificates:
#  <certificate_name>:
#    domain_name: <domain_name>
#    subject_alternative_names:   # (optional) list of alternative domain names
#      - <alt_domain_name_1>
#      - <alt_domain_name_2>
#    validation_method: <DNS or EMAIL>
#    validation_domain: <validation_domain> # (optional) domain for validation, defaults to domain_name
#    key_algorithm: <RSA_2048 or ECDSA_P256> # (optional) defaults to RSA_2048
#    validation_options:                       # (optional) list of validation options
#      - domain_name: <validation_domain_name>
#        validation_domain: <validation_domain> # (optional) domain for validation, defaults to domain_name
#    tags:                          # (optional) tags to apply to the certificate
#      <tag_name>: <certificate_name>
#    listener_port: <port> # (optional) port to associate with the certificate, defaults to load_balancer_listener_port
#    listener_arn: <arn> # (optional) ARN of the listener to associate with the certificate, defaults to empty
#    options:                     # (optional) options for the certificate
#      certificate_transparency_logging_preference: true | false # (optional) defaults to not set
variable "certificates" {
  description = "The certificates to create."
  type        = any
  default     = {}
}

variable "load_balancer_listener_arn" {
  description = "The ARN of the load balancer to associate with the certificates."
  type        = string
  default     = ""
}

variable "load_balancer_listener_port" {
  description = "The port of the load balancer to associate with the certificates."
  type        = number
  default     = -1
}

variable "lb_arn" {
  description = "The ARN of the load balancer to associate with the certificates."
  type        = string
  default     = ""
}