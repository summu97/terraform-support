# -------------------------
# App Service Plan
# -------------------------
output "app_service_plan_id" {
  value = module.app_service_plan.id
}

# -------------------------
# Azure CDN Frontdoor
# -------------------------
output "frontdoor_frontdoor_profile" {
  value = module.azure_cdn_frontdoor.frontdoor_profile
}

output "frontdoor_custom_domains" {
  value = module.azure_cdn_frontdoor.
}

output "frontdoor_endpoints" {
  value = module.azure_cdn_frontdoor.custom_domains
}

output "frontdoor_origin_groups" {
  value = module.azure_cdn_frontdoor.origin_groups
}

output "frontdoor_origins" {
  value = module.azure_cdn_frontdoor.origins
}

output "frontdoor_routes" {
  value = module.azure_cdn_frontdoor.routes
}

# -------------------------
# Redis Module Outputs
# -------------------------
output "redis_id" {
  value = module.azure_redis_cache.redis_id
}

output "redis_hostname" {
  value = module.azure_redis_cache.redis_hostname
}

output "redis_port" {
  value = module.azure_redis_cache.redis_port
}

# -------------------------
# Disk Encryption Set Outputs
# -------------------------
output "des_resource_id" {
  value = module.disk_encryption_set.resource_id
}

# -------------------------
# Autoscale Module Outputs
# -------------------------
output "autoscale_resource_id" {
  value = module.terraform-avm-res-insights-autoscalesetting.resource_id
}

output "autoscale_resource_name" {
  value = module.terraform-avm-res-insights-autoscalesetting.resource_name
}

output "autoscale_resource" {
  value = module.terraform-avm-res-insights-autoscalesetting.resource
}

# -------------------------
# App Service Plan
# -------------------------
output "app_service_plan_id" {
  value = module.app_service_plan.id
}

