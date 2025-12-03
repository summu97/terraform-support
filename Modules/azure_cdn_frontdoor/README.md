# azurerm_frontdoor

Terraform module to deploy an Azure CDN FrontDoor (Azure Front Door / CDN FrontDoor Profile) with origins, origin groups, endpoints, routes, custom domains, WAF/firewall policies, rule sets and diagnostics.

## Features
- Create FrontDoor profile with configurable SKU.
- Add endpoints, origins, origin groups, routes and routes' cache/forwarding settings.
- Create and configure custom domains (with TLS configuration).
- Create firewall policies and security policies.
- Wire diagnostic settings (use claranet/diagnostic-settings module).
- Support for managed identities.

## Requirements
- Terraform >= 1.3
- Providers:
  - azurerm ~> 4.31
  - azurecaf >= 1.2.28

## Inputs

**Required**
- `client_name` (string)
- `environment` (string)
- `logs_destinations_ids` (list(string))
- `resource_group_name` (string)
- `stack` (string)

**Optional**
- `custom_domains` (list(object)) — default `[]`
- `custom_name` (string) — default `""`
- `default_tags_enabled` (bool) — default `true`
- `diagnostic_settings_custom_name` (string) — default `"default"`
- `endpoints` (list(object)) — default `[]`
- `firewall_policies` (list(object)) — default `[]`
- `identity` (object) — default `{}`
- `extra_tags` (map) — default `{}`
- `name_prefix` / `name_suffix` (string) — default `""`
- `origin_groups`, `origins`, `routes`, `rule_sets`, `security_policies`, etc.

(See `variables.tf` for the full schema)

## Outputs
- `id` - FrontDoor profile id
- `name` - FrontDoor profile name
- `resource` - profile object
- Maps for created resources: `resource_endpoint`, `resource_origin`, `resource_custom_domain`, etc.

## Usage example
```hcl
module "frontdoor" {
  source = "./modules/azurerm_frontdoor"

  client_name          = "acme"
  environment          = "prod"
  stack                = "web"
  resource_group_name  = "rg-frontdoor-prod"
  logs_destinations_ids = [
    azurerm_log_analytics_workspace.myworkspace.id
  ]

  custom_domains = [
    {
      name      = "www-acme"
      host_name = "www.acme.com"
      tls = {
        certificate_type = "ManagedCertificate"
      }
    }
  ]

  endpoints = [
    { name = "frontdoor-endpoint-1" }
  ]
}
