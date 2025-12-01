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
# CDN Module Outputs
# -------------------------
output "cdn_profile_id" {
  value = module.cdn_profile.cdn_profile_id
}

output "cdn_profile_name" {
  value = module.cdn_profile.cdn_profile_name
}

# -------------------------
# Disk Encryption Set Outputs
# -------------------------
output "des_key_vault_key_url" {
  value = module.disk_encryption_set.key_vault_key_url
}

output "des_resource" {
  value = module.disk_encryption_set.resource
}

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
