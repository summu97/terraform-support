# ====================================
# Global Variables (shared across modules)
# ====================================
subscription_id     = "PROD_SUBSCRIPTION_ID"
resource_group_name = "prod-rg"


# ====================================
# Redis Cache Module Variables
# ====================================
redis_name          = "prod-redis-cache"
redis_location      = ""
redis_pricing_tier  = "Premium"  # Basic / Standard / Premium
redis_family        = "P"
redis_capacity      = 1
redis_enable_non_ssl_port = false

# Premium-only variables
redis_zones                   = ["1", "2", "3"]
redis_shard_count             = 3
redis_rdb_backup_enabled            = true
redis_rdb_backup_frequency          = 60
redis_rdb_storage_connection_string = "DefaultEndpointsProtocol=https;AccountName=prodsa;AccountKey=XXXX"
redis_subnet_id               = "/subscriptions/.../subnets/redis-subnet"

redis_tags = {
  environment = "prod"
}

# ====================================
# CDN Profile Module Variables
# ====================================
cdn_profile_name = "prod-cdn-profile"
cdn_location        = ""
cdn_pricing_tier = "Standard_Microsoft"

cdn_tags = {
  environment = "prod"
  department  = "IT"
}

# ====================================
# Disk Encryption Set Module Variables
# ====================================
des_name                = "des-prod-001"
des_location                = ""
des_key_vault_key_id        = "/subscriptions/<SUB>/resourceGroups/rg-kv-prod/providers/Microsoft.KeyVault/vaults/prod-kv/keys/prod-key"
des_managed_hsm_key_id      = null
des_key_vault_resource_id   = "/subscriptions/<SUB>/resourceGroups/rg-kv-prod/providers/Microsoft.KeyVault/vaults/prod-kv"
des_encryption_type         = "EncryptionAtRestWithCustomerKey"
des_auto_key_rotation_enabled = true
des_federated_client_id      = null
des_enable_telemetry         = true
des_lock = {
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
autoscale_location  = "East US"
autoscale_name      = "prod-autoscale-setting"

autoscale_target_resource_id = "/subscriptions/<SUBSCRIPTION-ID>/resourceGroups/rg-prod-app/providers/Microsoft.Web/serverfarms/prod-appserviceplan"

autoscale_profiles = {
  business_hours = {
    name = "prod-business-hours-scale"

    capacity = {
      minimum = 2
      default = 3
      maximum = 6
    }

    recurrence = {
      timezone = "UTC"
      days     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      hours    = [9, 10, 11, 12, 13, 14, 15, 16, 17]
      minutes  = [0]
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
          threshold        = 65
        }
        scale_action = {
          direction = "Increase"
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT5M"
        }
      }
    }
  }

  off_hours = {
    name = "prod-off-hours-scale"

    capacity = {
      minimum = 1
      default = 2
      maximum = 3
    }

    rules = {}
  }
}

autoscale_enable_telemetry = true
autoscale_enabled          = true

autoscale_notification = {
  email = {
    send_to_subscription_administrator    = true
    send_to_subscription_co_administrator = false
    custom_emails                         = ["prod-alerts@example.com"]
  }
}

autoscale_predictive = {
  scale_mode      = "Enabled"
  look_ahead_time = "PT30M"
}

autoscale_tags = {
  environment = "prod"
  owner       = "production-team"
}

# ====================================
# App Service Pln
# ====================================
app_service_plan_location = "East US"
app_service_plan_name     = "prod-appserviceplan"
app_service_plan_tier     = "Premium"
app_service_plan_size     = "P1v3"
app_service_plan_os_type  = "Linux"

app_service_plan_tags = {
  environment = "prod"
}
