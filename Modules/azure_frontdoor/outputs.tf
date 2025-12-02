output "profile_id" {
  description = "Front Door profile resource id"
  value       = azurerm_cdn_frontdoor_profile.this.id
}

output "endpoint_hostname" {
  description = "Front Door endpoint host name"
  value = [for fe in azurerm_cdn_frontdoor_endpoint.this : fe.value.host_name]
}
