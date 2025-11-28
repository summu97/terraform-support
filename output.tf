# -------------------------
# Redis Module Outputs
# -------------------------
output "redis_id" {
  value = module.redis.redis_id
}

output "redis_hostname" {
  value = module.redis.redis_hostname
}

output "redis_port" {
  value = module.redis.redis_port
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
  value = module.des.key_vault_key_url
}

output "des_resource" {
  value = module.des.resource
}

output "des_resource_id" {
  value = module.des.resource_id
}

# -------------------------
# Autoscale Module Outputs
# -------------------------
output "autoscale_resource_id" {
  value = module.autoscale.resource_id
}

output "autoscale_resource_name" {
  value = module.autoscale.resource_name
}

output "autoscale_resource" {
  value = module.autoscale.resource
}

# -------------------------
# App Service Plan
# -------------------------
output "app_service_plan_id" {
  value = module.app_service_plan.id
}
