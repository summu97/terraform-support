output "cdn_profile_id" {
  description = "ID of the CDN profile"
  value       = azurerm_cdn_profile.this.id
}

output "cdn_profile_name" {
  description = "Name of the CDN profile"
  value       = azurerm_cdn_profile.this.name
}
