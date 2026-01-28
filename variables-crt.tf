##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# dns_zone_domain: "example.com" # (Optional) The DNS zone domain, used if zone_id is not provided. Default: ""
variable "dns_zone_domain" {
  description = "The DNS zone domain, used if zone_id is not provided."
  type        = string
  default     = ""
}

# dns_zone_id: "Z1234567890" # (Optional) The DNS zone to use for the DNS records, must be provided if dns_zone_domain is not provided. Default: ""
variable "dns_zone_id" {
  description = "The DNS zone to use for the DNS records, must be provided if dns_zone_domain is not provided."
  type        = string
  default     = ""
}

# private_dns_zone: false # (Optional) If true, the DNS zone to search is private. Default: false
variable "private_dns_zone" {
  description = "If true, the DNS zone to search is private."
  type        = bool
  default     = false
}

# external_dns_zone: false # (Optional) If true, the DNS zone is external and assumed no local Route53 validation required. Default: false
variable "external_dns_zone" {
  description = "If true, the DNS zone is external and assumed no local Route53 validation required."
  type        = bool
  default     = false
}

## certificates configuration - YAML format
# certificates:
#   <certificate_name>:          # (Required) The name of the certificate
#     domain_name: "example.com" # (Required) The primary domain name for the certificate
#     subject_alternative_names: # (Optional) List of alternative domain names. Default: []
#       - "www.example.com"
#     validation_method: "DNS"   # (Optional) Method to validate domain ownership. Possible values: DNS, EMAIL. Default: DNS
#     validation_domain: "example.com" # (Optional) Domain for validation, defaults to domain_name. Default: ""
#     key_algorithm: "RSA_2048"  # (Optional) The algorithm to use for the key. Possible values: RSA_2048, ECDSA_P256. Default: RSA_2048
#     validation_option:         # (Optional) List of validation options for different domains. Default: []
#       - domain_name: "example.com"
#         validation_domain: "example.com" # (Optional) domain for validation, defaults to domain_name
#     tags:                      # (Optional) Tags to apply to the certificate. Default: {}
#       Environment: "production"
#     listener_port: 443         # (Optional) Port to associate with the certificate. Default: var.load_balancer_listener_port
#     listener_arn: "arn:aws:..." # (Optional) ARN of the listener to associate with the certificate. Default: ""
#     options:                   # (Optional) Additional options for the certificate. Default: {}
#       certificate_transparency_logging_preference: true # (Optional) Whether to enable transparency logging. Possible values: true, false. Default: true
variable "certificates" {
  description = "The certificates to create."
  type        = any
  default     = {}
}

# load_balancer_listener_arn: "arn:aws:..." # (Optional) The ARN of the load balancer listener to associate with the certificates. Default: ""
variable "load_balancer_listener_arn" {
  description = "The ARN of the load balancer to associate with the certificates."
  type        = string
  default     = ""
}

# load_balancer_listener_port: 443 # (Optional) The port of the load balancer to associate with the certificates. Default: -1
variable "load_balancer_listener_port" {
  description = "The port of the load balancer to associate with the certificates."
  type        = number
  default     = -1
}

# lb_arn: "arn:aws:..." # (Optional) The ARN of the load balancer to associate with the certificates. Default: ""
variable "lb_arn" {
  description = "The ARN of the load balancer to associate with the certificates."
  type        = string
  default     = ""
}

# cross_account: false # (Optional) The cross account to use for the Certificate domain, aws.cross_account provider must be set to module. Default: false
variable "cross_account" {
  description = "The cross account to use for the Certificate domain, aws.cross_account provider must be set to module."
  type        = bool
  default     = false
  nullable    = false
}
