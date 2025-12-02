# Azure Front Door (CDN FrontDoor Profile) Terraform module

This module provisions an Azure Front Door (Standard / Premium) profile and endpoint(s) using the AzureRM provider resources:
- `azurerm_cdn_frontdoor_profile`
- `azurerm_cdn_frontdoor_endpoint`
- optional diagnostic setting to send logs to Log Analytics

## Usage
Pass `resource_group_name`, `name`, `backend_pools`, `frontend_endpoints` and `routes`.

### Notes
- For custom domains and HTTPS certificate configuration, add `azurerm_cdn_frontdoor_custom_domain` and `azurerm_cdn_frontdoor_custom_domain_https_configuration`, referencing Key Vault or managed certificates as per your security posture.
- The module sets `prevent_destroy = true` on the profile by default — remove if you need different lifecycle behavior.
