# ====================================
# Global Variables (shared across modules)
# ====================================
subscription_id     = "DEV_SUBSCRIPTION_ID"
resource_group_name = "dev-rg"

# ====================================
# App Service Plan
# ====================================
app_service_plan_location = "East US"
app_service_plan_name     = "dev-appserviceplan"
app_service_plan_size     = "B1"
app_service_plan_os       = "Linux"

app_service_plan_tags = {
  environment = "dev"
}


# ====================================
# Azure CDN Frontdoor
# ====================================
frontdoor_location            = "East US"
frontdoor_name_prefix         = "adq"
frontdoor_client_name         = "demo"
frontdoor_environment         = "dev"
frontdoor_stack               = "app"
frontdoor_name_suffix         = "fd"
frontdoor_custom_name         = ""

frontdoor_extra_tags = {
  project = "terraform-frontdoor"
  env     = "dev"
}

frontdoor_custom_domains = [
  {
    name      = "frontend1"
    host_name = "www.example.com"
    tls = {
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    }
  }
]

frontdoor_endpoints = [
  { name = "frontend1-endpoint" }
]

frontdoor_origin_groups = [
  {
    name     = "backend-group-1"
    origins  = [
      { host_name = "app1.internal.cloud" },
      { host_name = "app2.internal.cloud" }
    ]
    health_probe = {
      interval_in_seconds = 30
      path                = "/health"
      protocol            = "Https"
      request_type        = "GET"
    }
    load_balancing = {
      additional_latency_in_milliseconds = 50
      sample_size                        = 4
      successful_samples_required        = 3
    }
    session_affinity_enabled = true
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
  }
]

frontdoor_origins = [
  {
    name              = "origin1"
    origin_group_name = "backend-group-1"
    host_name         = "app1.internal.cloud"
    http_port         = 80
    https_port        = 443
    priority          = 1
    weight            = 1
    enabled           = true
  },
  {
    name              = "origin2"
    origin_group_name = "backend-group-1"
    host_name         = "app2.internal.cloud"
    http_port         = 80
    https_port        = 443
    priority          = 1
    weight            = 1
    enabled           = true
  }
]

frontdoor_routes = [
  {
    name                   = "route1"
    endpoint_name          = "frontend1-endpoint"
    origin_group_name      = "backend-group-1"
    forwarding_protocol    = "HttpsOnly"
    origin_names      = ["origin1", "origin2"]
    https_redirect_enabled = true
    patterns_to_match      = ["/*"]
    accepted_protocols     = ["Https"]
    frontend_endpoints     = ["frontend1"]
  }
]


# ====================================
# Redis Cache Module Variables
# ====================================
redis_name          = "dev-redis-cache"
redis_location      = "East US"
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
# Disk Encryption Set Module Variables
# ====================================
des_name                = "des-dev-001"
des_location                = "East US"
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

# Autoscale profiles
autoscale_profiles = {
  default = {
    name = "dev-default-scaling"

    capacity = {
      minimum = 1
      default = 1
      maximum = 2
    }

    rules = [
      {
        metric_trigger = {
          metric_name              = "CpuPercentage"
          metric_resource_id       = "/subscriptions/<SUBSCRIPTION-ID>/resourceGroups/rg-dev-app/providers/Microsoft.Web/serverfarms/dev-appserviceplan"
          operator                 = "GreaterThan"
          statistic                = "Average"
          time_aggregation         = "Average"
          time_grain               = "PT1M"
          time_window              = "PT5M"
          threshold                = 70
          divide_by_instance_count = false
        }
        scale_action = {
          direction = "Increase"
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT5M"
        }
      },
      {
        metric_trigger = {
          metric_name              = "CpuPercentage"
          metric_resource_id       = "/subscriptions/<SUBSCRIPTION-ID>/resourceGroups/rg-dev-app/providers/Microsoft.Web/serverfarms/dev-appserviceplan"
          operator                 = "LessThan"
          statistic                = "Average"
          time_aggregation         = "Average"
          time_grain               = "PT1M"
          time_window              = "PT5M"
          threshold                = 30
          divide_by_instance_count = false
        }
        scale_action = {
          direction = "Decrease"
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT5M"
        }
      }
    ]

    # Optional recurrence (weekly schedule)
    recurrence = {
      timezone = "UTC"
      days     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      hours    = [9, 12, 15]
      minutes  = [0]
    }

    # Optional fixed_date
    fixed_date = {
      start    = "2025-12-01T00:00:00Z"
      end      = "2025-12-31T23:59:59Z"
      timezone = "UTC"
    }
  }
}

autoscale_enable_telemetry = true
autoscale_enabled          = true
autoscale_notification     = null
autoscale_predictive       = null

autoscale_tags = {
  environment = "dev"
  owner       = "devops"
}


