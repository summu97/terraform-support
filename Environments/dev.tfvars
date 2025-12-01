# ====================================
# Global Variables (shared across modules)
# ====================================
subscription_id     = "DEV_SUBSCRIPTION_ID"
resource_group_name = "dev-rg"

# ====================================
# Redis Cache Module Variables
# ====================================
redis_name          = "dev-redis-cache"
redis_location      = ""
redis_pricing_tier  = "Standard"  # Basic / Standard / Premium
redis_family        = "C"
redis_capacity      = 1
redis_enable_non_ssl_port = false

# Premium-only variables (ignored if tier is not Premium)
redis_zones                        = null
redis_shard_count                  = null
redis_rdb_backup_enabled                 = false
redis_rdb_backup_frequency               = null
redis_rdb_storage_connection_string      = null
redis_subnet_id                     = null

redis_tags = {
  environment = "dev"
}

# ====================================
# CDN Profile Module Variables
# ====================================
cdn_profile_name    = "dev-cdn-profile"
cdn_location        = ""
cdn_pricing_tier    = "Standard_Microsoft"

cdn_tags = {
  environment = "dev"
  department  = "IT"
}

# ====================================
# Disk Encryption Set Module Variables
# ====================================
des_name                = "des-dev-001"
des_location                = ""
des_key_vault_key_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-kv-dev/providers/Microsoft.KeyVault/vaults/my-kv/keys/mykey"
des_managed_hsm_key_id      = null
des_key_vault_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-kv-dev/providers/Microsoft.KeyVault/vaults/my-kv"
des_encryption_type         = "EncryptionAtRestWithCustomerKey"
des_auto_key_rotation_enabled = false
des_federated_client_id      = null
des_enable_telemetry         = true
des_lock                     = null

des_tags = {
  environment = "dev"
  project     = "disk-encryption"
}

# ====================================
# Autoscale Module Variables
# ====================================
autoscale_location  = "East US"
autoscale_name      = "dev-autoscale-setting"

# Attach autoscale to DEV App Service
autoscale_target_resource_id = "/subscriptions/<SUBSCRIPTION-ID>/resourceGroups/rg-dev-app/providers/Microsoft.Web/serverfarms/dev-appserviceplan"

# Autoscale profiles (map)
autoscale_profiles = {
  default = {
    name = "dev-default-scaling"

    capacity = {
      minimum = 1
      default = 1
      maximum = 2
    }

    rules = {
      cpu_scale_out = {
        metric_trigger = {
          metric_name      = "CpuPercentage"
          operator         = "GreaterThan"
          statistic        = "Average"
          time_aggregation = "Average"
          time_grain       = "PT1M"
          time_window      = "PT5M"
          threshold        = 70
          dimensions       = []  # Optional
        }
        scale_action = {
          direction = "Increase"
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT5M"
        }
      }

      cpu_scale_in = {
        metric_trigger = {
          metric_name      = "CpuPercentage"
          operator         = "LessThan"
          statistic        = "Average"
          time_aggregation = "Average"
          time_grain       = "PT1M"
          time_window      = "PT5M"
          threshold        = 30
          dimensions       = []  # Optional
        }
        scale_action = {
          direction = "Decrease"
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT5M"
        }
      }
    }

    # Optional recurrence example (weekly schedule)
    recurrence = {
      timezone = "UTC"
      days     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      hours    = [9, 12, 15]
      minutes  = [0]
    }
  }
}

autoscale_enable_telemetry = true
autoscale_enabled          = true

# Optional notifications (null or configure if needed)
autoscale_notification = null

# Optional predictive scaling (null or configure if needed)
autoscale_predictive = null

autoscale_tags = {
  environment = "dev"
  owner       = "devops"
}

# ====================================
# App Service Plan
# ====================================
app_service_plan_location = "East US"
app_service_plan_name     = "dev-appserviceplan"
app_service_plan_tier     = "Basic"
app_service_plan_size     = "B1"
app_service_plan_os_type  = "Linux"
app_service_plan_tags = {
  environment = "dev"
}
