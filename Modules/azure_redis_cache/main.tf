locals {
  is_premium = var.redis_pricing_tier == "Premium"
}

resource "azurerm_redis_cache" "this" {
  redis_name                = var.redis_name
  redis_location            = var.redis_location
  resource_group_name       = var.resource_group_name
  redis_capacity            = var.redis_capacity
  redis_family              = var.redis_family
  redis_sku_name            = var.redis_pricing_tier
  redis_enable_non_ssl_port = var.redis_enable_non_ssl_port

  # Premium Tier Enhancements
  # --------------------------

  # 1. Availability Zones (Premium Only)
  zones = local.is_premium ? var.redis_zones : null

  # 2. Sharding / Clustering (Premium Only)
  shard_count = local.is_premium ? var.redis_shard_count : null

  # 3. Data Persistence (Premium Only)
  redis_configuration = local.is_premium ? {
    "rdb-backup-enabled"          = var.redis_rdb_backup_enabled
    "rdb-backup-frequency"        = var.redis_rdb_backup_frequency
    "rdb-storage-connection-string" = var.redis_rdb_storage_connection_string
  } : {}

  # 4. Virtual Network Integration (Premium Only)
  subnet_id = local.is_premium ? var.redis_subnet_id : null

  tags = var.redis_tags
}
