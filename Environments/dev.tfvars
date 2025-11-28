# ====================================
# Global Variables (shared across modules)
# ====================================
subscription_id     = "DEV_SUBSCRIPTION_ID"
location            = "eastus"
resource_group_name = "dev-rg"

# ====================================
# Module-Specific Tags
# ====================================
redis_tags = {
  environment = "dev"
}

cdn_tags = {
  environment = "dev"
  department  = "IT"
}

des_tags = {
  environment = "dev"
  project     = "disk-encryption"
}

autoscale_tags = {
  environment = "dev"
  owner       = "devops"
}

# ====================================
# Redis Cache Module Variables
# ====================================
redis_name          = "dev-redis-cache"
redis_pricing_tier  = "Standard"  # Basic / Standard / Premium
redis_family        = "C"
redis_capacity      = 1
enable_non_ssl_port = false

# Premium-only variables (ignored if tier is not Premium)
redis_zones                        = null
redis_shard_count                  = null
rdb_backup_enabled                 = false
rdb_backup_frequency               = null
rdb_storage_connection_string      = null
redis_subnet_id                     = null

# ====================================
# CDN Profile Module Variables
# ====================================
cdn_profile_name    = "dev-cdn-profile"
cdn_pricing_tier    = "Standard_Microsoft"

# ====================================
# Disk Encryption Set Module Variables
# ====================================
des_name                = "des-dev-001"
key_vault_key_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-kv-dev/providers/Microsoft.KeyVault/vaults/my-kv/keys/mykey"
managed_hsm_key_id      = null
key_vault_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-kv-dev/providers/Microsoft.KeyVault/vaults/my-kv"
encryption_type         = "EncryptionAtRestWithCustomerKey"
auto_key_rotation_enabled = false
federated_client_id      = null
enable_telemetry         = true
lock                     = null

# ====================================
# Autoscale Module Variables
# ====================================
autoscale_name                = "autoscale-dev"
autoscale_target_resource_id  = "/subscriptions/<SUB-ID>/resourceGroups/rg-dev-app/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-dev"
autoscale_enabled             = true
enable_telemetry              = true

profiles = {
  dev-default = {
    name = "DevProfile"
    capacity = {
      default = 1
      maximum = 2
      minimum = 1
    }

    rules = {
      cpu-scale-out = {
        metric_trigger = {
          metric_name      = "Percentage CPU"
          operator         = "GreaterThan"
          statistic        = "Average"
          time_aggregation = "Average"
          time_grain       = "PT1M"
          time_window      = "PT5M"
          threshold        = 70
        }
        scale_action = {
          direction = "Increase"
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT5M"
        }
      }

      cpu-scale-in = {
        metric_trigger = {
          metric_name      = "Percentage CPU"
          operator         = "LessThan"
          statistic        = "Average"
          time_aggregation = "Average"
          time_grain       = "PT1M"
          time_window      = "PT5M"
          threshold        = 30
        }
        scale_action = {
          direction = "Decrease"
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT10M"
        }
      }
    }
  }
}

