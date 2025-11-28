# -------------------------
# Redis Cache Module
# -------------------------
module "azure_redis_cache" {
  source = "./Modules/azure_redis_cache"

  name                          = var.redis_name
  location                      = var.redis_location
  resource_group_name           = var.resource_group_name
  pricing_tier                  = var.redis_pricing_tier
  capacity                      = var.redis_capacity
  family                        = var.redis_family
  sku_name                      = var.redis_pricing_tier
  enable_non_ssl_port           = var.redis_enable_non_ssl_port
  zones                         = var.redis_zones
  shard_count                   = var.redis_shard_count
  rdb_backup_enabled            = var.redis_rdb_backup_enabled
  rdb_backup_frequency          = var.redis_rdb_backup_frequency
  rdb_storage_connection_string = var.redis_rdb_storage_connection_string
  subnet_id                     = var.redis_subnet_id
  tags                          = var.redis_tags
}

# -------------------------
# CDN Profile Module
# -------------------------
module "cdn_profile" {
  source = "./Modules/cdn_profile"

  cdn_profile_name    = var.cdn_profile_name
  resource_group_name = var.resource_group_name
  location            = var.location
  pricing_tier        = var.cdn_pricing_tier

  tags = var.tags
}

# -------------------------
# Disk Encryption Set Module
# -------------------------
module "desk_encryption_set" {
  source = "./Modules/disk_encryption_set"

  name                      = var.des_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  key_vault_key_id          = var.key_vault_key_id
  managed_hsm_key_id        = var.managed_hsm_key_id
  encryption_type           = var.encryption_type
  auto_key_rotation_enabled = var.auto_key_rotation_enabled
  federated_client_id       = var.federated_client_id
  key_vault_resource_id     = var.key_vault_resource_id
  enable_telemetry          = var.enable_telemetry
  lock                      = var.lock

  tags = var.tags
}

# -------------------------
# Autoscale Module
# -------------------------
module "autoscale" {
  source = "./Modules/terraform-avm-res-insights-autoscalesetting"

  name                 = var.autoscale_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  target_resource_id   = var.autoscale_target_resource_id
  enabled              = var.autoscale_enabled
  notification         = var.autoscale_notification
  profiles             = var.autoscale_profiles
  predictive           = var.autoscale_predictive
  enable_telemetry     = var.enable_telemetry

  tags = var.tags
}

# -------------------------
# app_service_plan
# -------------------------

module "app_service_plan" {
  source = "./Modules/app_service_plan"

  name                  = var.app_service_plan_name
  resource_group_name   = var.resource_group_name
  location              = var.app_service_plan_location
  tier                  = var.app_service_plan_tier
  size                  = var.app_service_plan_size
  os_type               = var.app_service_plan_os_type
  tags                  = var.app_service_plan_tags
}
