locals {
  is_premium = var.pricing_tier == "Premium"
}

resource "azurerm_redis_cache" "this" {
  name                = var.redis_name
  location            = var.redis_location
  resource_group_name = var.resource_group_name
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_pricing_tier
  enable_non_ssl_port = var.redis_enable_non_ssl_port

  # Premium Tier Enhancements
  # --------------------------

  # 1. Availability Zones (Premium Only)
  zones = local.is_premium ? var.zones : null

  # 2. Sharding / Clustering (Premium Only)
  shard_count = local.is_premium ? var.shard_count : null

  # 3. Data Persistence (Premium Only)
  redis_configuration = local.is_premium ? {
    "rdb-backup-enabled"          = var.rdb_backup_enabled
    "rdb-backup-frequency"        = var.rdb_backup_frequency
    "rdb-storage-connection-string" = var.rdb_storage_connection_string
  } : {}

  # 4. Virtual Network Integration (Premium Only)
  subnet_id = local.is_premium ? var.subnet_id : null

  tags = var.redis_tags
}
