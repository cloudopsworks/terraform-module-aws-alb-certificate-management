locals {
  local_vars  = yamldecode(file("./inputs.yaml"))
  spoke_vars  = yamldecode(file(find_in_parent_folders("spoke-inputs.yaml")))
  region_vars = yamldecode(file(find_in_parent_folders("region-inputs.yaml")))
  env_vars    = yamldecode(file(find_in_parent_folders("env-inputs.yaml")))
  global_vars = yamldecode(file(find_in_parent_folders("global-inputs.yaml")))

  local_tags  = jsondecode(file("./local-tags.json"))
  spoke_tags  = jsondecode(file(find_in_parent_folders("spoke-tags.json")))
  region_tags = jsondecode(file(find_in_parent_folders("region-tags.json")))
  env_tags    = jsondecode(file(find_in_parent_folders("env-tags.json")))
  global_tags = jsondecode(file(find_in_parent_folders("global-tags.json")))

  # Cross Account variables
  cross_account              = try(local.local_vars.cross_account.enabled, false)
  cross_account_alias        = try(local.local_vars.cross_account.alias, "cross_account")
  cross_account_region       = try(local.local_vars.cross_account.region, local.global_vars.default.region)
  cross_account_sts_role_arn = try(local.local_vars.cross_account.sts_role_arn, local.global_vars.default.sts_role_arn)
  cross_account_providers = try(local.local_vars.cross_account.enabled, false) ? {
    "aws.cross_account" = "aws.${try(local.local_vars.cross_account.alias, "cross_account")}"
  } : {}

  tags = merge(
    local.global_tags,
    local.env_tags,
    local.region_tags,
    local.spoke_tags,
    local.local_tags
  )
}

include "root" {
  path = find_in_parent_folders("{{ .RootFileName }}")
}
{{ if .alb_enabled }}
dependency "alb" {
  config_path = "{{ .alb_path }}"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    load_balancer_arn      = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/alb-1234567890123456/1234567890123456"
    load_balancer_dns_name = "alb-1234567890123456.us-east-1.elb.amazonaws.com"
    load_balancer_zone_id  = "Z1234567890123456"
  }
}
{{ end }}
# Generate global provider block
generate "provider_l" {
  path = "provider.l.tf"
  #   disable     = !local.cross_account
  if_exists   = "overwrite_terragrunt"
  if_disabled = "remove_terragrunt"
  contents    = <<EOF
provider "aws" {
  alias = "${local.cross_account_alias}"
  region = "${local.cross_account_region}"
  assume_role {
    role_arn     = "${local.cross_account_sts_role_arn}"
    session_name = "terragrunt"
  }
}
EOF
}

terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {
  is_hub     = {{ .is_hub }}
  org        = local.env_vars.org
  spoke_def  = local.spoke_vars.spoke
  {{- range .requiredVariables }}
  {{- if ne .Name "org" }}
  {{ .Name }} = local.local_vars.{{ .Name }}
  {{- end }}
  {{- end }}
  {{- range .optionalVariables }}
  {{- if not (eq .Name "extra_tags" "is_hub" "spoke_def" "org" "cross_account") }}
  {{- if and $.alb_enabled (eq .Name lb_arn) }}
  {{ .Name }} = dependency.alb.outputs.load_balancer_arn
  {{- else }}
  {{ .Name }} = try(local.local_vars.{{ .Name }}, {{ .DefaultValue }})
  {{- end }}
  {{- end }}
  {{- end }}
  cross_account = local.cross_account
  extra_tags = local.tags
}