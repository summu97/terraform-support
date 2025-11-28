# ====================================
# Global Variables (shared across modules)
# ====================================
subscription_id     = "PROD_SUBSCRIPTION_ID"
location            = "Central India"
resource_group_name = "prod-rg"


# ====================================
# Redis Cache Module Variables
# ====================================
redis_name          = "prod-redis-cache"
redis_pricing_tier  = "Premium"  # Basic / Standard / Premium
redis_family        = "P"
redis_capacity      = 1
enable_non_ssl_port = false

# Premium-only variables
redis_zones                   = ["1", "2", "3"]
redis_shard_count             = 3
rdb_backup_enabled            = true
rdb_backup_frequency          = 60
rdb_storage_connection_string = "DefaultEndpointsProtocol=https;AccountName=prodsa;AccountKey=XXXX"
redis_subnet_id               = "/subscriptions/.../subnets/redis-subnet"

redis_tags = {
  environment = "prod"
}

# ====================================
# CDN Profile Module Variables
# ====================================
cdn_profile_name = "prod-cdn-profile"
cdn_pricing_tier = "Standard_Microsoft"

cdn_tags = {
  environment = "prod"
  department  = "IT"
}

# ====================================
# Disk Encryption Set Module Variables
# ====================================
des_name                = "des-prod-001"
key_vault_key_id        = "/subscriptions/<SUB>/resourceGroups/rg-kv-prod/providers/Microsoft.KeyVault/vaults/prod-kv/keys/prod-key"
managed_hsm_key_id      = null
key_vault_resource_id   = "/subscriptions/<SUB>/resourceGroups/rg-kv-prod/providers/Microsoft.KeyVault/vaults/prod-kv"
encryption_type         = "EncryptionAtRestWithCustomerKey"
auto_key_rotation_enabled = true
federated_client_id      = null
enable_telemetry         = true
lock = {
  kind = "CanNotDelete"
  name = "lock-des-prod-001"
}

des_tags = {
  environment = "prod"
  project     = "disk-encryption"
  owner       = "platform-team"
}

# ====================================
# Autoscale Module Variables
# ====================================
autoscale_name                = "autoscale-prod"
autoscale_target_resource_id  = "/subscriptions/<SUB-ID>/resourceGroups/rg-prod-app/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-prod"
autoscale_enabled             = true
enable_telemetry              = true

profiles = {
  prod-default = {
    name = "ProdProfile"
    capacity = {
      default = 3
      maximum = 10
      minimum = 3
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
          threshold        = 60
        }
        scale_action = {
          direction = "Increase"
          type      = "ChangeCount"
          value     = "2"
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
          threshold        = 40
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

autoscale_tags = {
  environment = "prod"
  owner       = "platform-team"
  critical    = "true"
}
# ====================================
# App Service Pln
# ====================================
app_service_plan_name = "prod-asp"
app_service_plan_tier                 = "PremiumV3"
app_service_plan_size                 = "P1v3"

app_service_plan_tags = {
  environment = "prod"
  project     = "appservice"
}
