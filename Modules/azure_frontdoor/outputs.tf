output "frontdoor_profile" {
  value = azurerm_cdn_frontdoor_profile.main
}

output "custom_domains" {
  value = azurerm_cdn_frontdoor_custom_domain.main
}

output "endpoints" {
  value = azurerm_cdn_frontdoor_endpoint.main
}

output "origin_groups" {
  value = azurerm_cdn_frontdoor_origin_group.main
}

output "origins" {
  value = azurerm_cdn_frontdoor_origin.main
}

output "routes" {
  value = azurerm_cdn_frontdoor_route.main
}
