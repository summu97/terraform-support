# -------------------------
# Redis Cache Module
# -------------------------
module "azure_redis_cache" {
  source = "./Modules/azure_redis_cache"

  redis_name                          = var.redis_name
  redis_location                      = var.redis_location
  resource_group_name                 = var.resource_group_name
  redis_pricing_tier                  = var.redis_pricing_tier
  redis_capacity                      = var.redis_capacity
  redis_family                        = var.redis_family
  redis_enable_non_ssl_port           = var.redis_enable_non_ssl_port
  redis_zones                         = var.redis_zones
  redis_shard_count                   = var.redis_shard_count
  redis_rdb_backup_enabled            = var.redis_rdb_backup_enabled
  redis_rdb_backup_frequency          = var.redis_rdb_backup_frequency
  redis_rdb_storage_connection_string = var.redis_rdb_storage_connection_string
  redis_subnet_id                     = var.redis_subnet_id
  redis_tags                          = var.redis_tags
}

# -------------------------
# CDN Profile Module
# -------------------------
module "cdn_profile" {
  source = "./Modules/cdn_profile"

  cdn_profile_name       = var.cdn_profile_name
  resource_group_name    = var.resource_group_name
  cdn_location           = var.cdn_location
  cdn_pricing_tier       = var.cdn_pricing_tier
  cdn_tags               = var.cdn_tags
}

# -------------------------
# Disk Encryption Set Module
# -------------------------
module "disk_encryption_set" {
  source = "./Modules/disk_encryption_set"

  des_name                     = var.des_name
  des_location                 = var.des_location
  resource_group_name          = var.resource_group_name
  des_key_vault_key_id          = var.des_key_vault_key_id
  des_managed_hsm_key_id        = var.des_managed_hsm_key_id
  des_encryption_type           = var.des_encryption_type
  des_auto_key_rotation_enabled = var.des_auto_key_rotation_enabled
  des_tags                      = var.des_tags
  des_federated_client_id       = var.des_federated_client_id
  des_key_vault_resource_id     = var.des_key_vault_resource_id
  des_lock                      = var.des_lock
  des_enable_telemetry          = var.des_enable_telemetry

}

# -------------------------
# Autoscale Module
# -------------------------
module "terraform-avm-res-insights-autoscalesetting" {
  source = "./Modules/terraform-avm-res-insights-autoscalesetting"

  autoscale_name               = var.autoscale_name
  resource_group_name          = var.resource_group_name
  autoscale_location           = var.autoscale_location
  autoscale_target_resource_id = var.autoscale_target_resource_id
  autoscale_enabled            = var.autoscale_enabled
  autoscale_tags               = var.autoscale_tags
  autoscale_enable_telemetry   = var.autoscale_enable_telemetry
  autoscale_notification       = var.autoscale_notification
  autoscale_profiles           = var.autoscale_profiles
  autoscale_predictive         = var.autoscale_predictive
}

# -------------------------
# app_service_plan
# -------------------------

module "app_service_plan" {
  source = "./Modules/app_service_plan"

  app_service_plan_name                  = var.app_service_plan_name
  resource_group_name                    = var.resource_group_name
  app_service_plan_location              = var.app_service_plan_location
  app_service_plan_tier                  = var.app_service_plan_tier
  app_service_plan_size                  = var.app_service_plan_size
  app_service_plan_os                    = var.app_service_plan_os
  app_service_plan_tags                  = var.app_service_plan_tags
}
