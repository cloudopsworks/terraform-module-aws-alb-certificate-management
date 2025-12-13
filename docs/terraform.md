## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.26.0 |
| <a name="provider_aws.cross_account"></a> [aws.cross\_account](#provider\_aws.cross\_account) | 6.26.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.cross](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_lb_listener_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_route53_record.cross_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_listener) | data source |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_listener) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.cert_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_route53_zone.cross_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificates"></a> [certificates](#input\_certificates) | The certificates to create. | `any` | `{}` | no |
| <a name="input_cross_account"></a> [cross\_account](#input\_cross\_account) | The cross account to use for the Certificate domain, aws.cross\_account provider must be set to module. | `bool` | `false` | no |
| <a name="input_dns_zone_domain"></a> [dns\_zone\_domain](#input\_dns\_zone\_domain) | The DNS zone domain, used if zone\_id is not provided. | `string` | `""` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | The DNS zone to use for the DNS records, must be provided if dns\_zone\_domain is not provided. | `string` | `""` | no |
| <a name="input_external_dns_zone"></a> [external\_dns\_zone](#input\_external\_dns\_zone) | If true, the DNS zone is external and assumed no local Route53 validation required. | `bool` | `false` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_lb_arn"></a> [lb\_arn](#input\_lb\_arn) | The ARN of the load balancer to associate with the certificates. | `string` | `""` | no |
| <a name="input_load_balancer_listener_arn"></a> [load\_balancer\_listener\_arn](#input\_load\_balancer\_listener\_arn) | The ARN of the load balancer to associate with the certificates. | `string` | `""` | no |
| <a name="input_load_balancer_listener_port"></a> [load\_balancer\_listener\_port](#input\_load\_balancer\_listener\_port) | The port of the load balancer to associate with the certificates. | `number` | `-1` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_private_dns_zone"></a> [private\_dns\_zone](#input\_private\_dns\_zone) | If true, the DNS zone to search is private. | `bool` | `false` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificates"></a> [certificates](#output\_certificates) | n/a |
| <a name="output_listener_certificates"></a> [listener\_certificates](#output\_listener\_certificates) | n/a |
