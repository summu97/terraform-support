# ====================================
# Global Variables (shared across modules)
# ====================================
subscription_id     = "QA_SUBSCRIPTION_ID"
location            = "eastus2"
resource_group_name = "qa-rg"


# ====================================
# Redis Cache Module Variables
# ====================================
redis_name          = "qa-redis-cache"
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

redis_tags = {
  environment = "qa"
}

# ====================================
# CDN Profile Module Variables
# ====================================
cdn_profile_name    = "qa-cdn-profile"
cdn_pricing_tier    = "Standard_Microsoft"

cdn_tags = {
  environment = "qa"
  department  = "IT"
}

# ====================================
# Disk Encryption Set Module Variables
# ====================================
des_name                = "des-qa-001"
key_vault_key_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-kv-qa/providers/Microsoft.KeyVault/vaults/qa-kv/keys/qa-key"
managed_hsm_key_id      = null
key_vault_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-kv-qa/providers/Microsoft.KeyVault/vaults/qa-kv"
encryption_type         = "EncryptionAtRestWithCustomerKey"
auto_key_rotation_enabled = false
federated_client_id      = null
enable_telemetry         = true
lock                     = null

des_tags = {
  environment = "qa"
  project     = "disk-encryption"
}

# ====================================
# Autoscale Module Variables
# ====================================
autoscale_name                = "autoscale-qa"
autoscale_target_resource_id  = "/subscriptions/<SUB-ID>/resourceGroups/rg-qa-app/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-qa"
autoscale_enabled             = true
enable_telemetry              = true

profiles = {
  qa-default = {
    name = "QAProfile"
    capacity = {
      default = 2
      maximum = 4
      minimum = 2
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
          threshold        = 65
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
          threshold        = 35
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
  environment = "qa"
  owner       = "devops"
}
# ====================================
# App Service Plan
# ====================================
app_service_plan_name = "qa-asp"
app_service_plan_tier                 = "Standard"
app_service_plan_size                 = "S1"

app_service_plan_tags = {
  environment = "qa"
  project     = "appservice"
}
