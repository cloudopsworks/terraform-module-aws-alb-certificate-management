##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
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