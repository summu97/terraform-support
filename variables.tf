#---------------------------
# GLOBAL / COMMON VARIABLES
#---------------------------

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Common Resource Group for modules"
  type        = string
}

#---------------------------
# REDIS MODULE VARIABLES
#---------------------------

variable "redis_name" {
  description = "DNS name for the Redis Cache"
  type        = string
}

variable "redis_location" {
  description = "Azure Region"
  type        = string
}

variable "redis_pricing_tier" {
  description = "Redis pricing tier (Basic/Standard/Premium)"
  type        = string
}

variable "redis_family" {
  description = "Redis family (C or P)"
  type        = string
}

variable "redis_capacity" {
  description = "SKU capacity (0-6)"
  type        = number
}

variable "redis_enable_non_ssl_port" {
  type        = bool
  default     = false
}

variable "redis_zones" {
  description = "Availability zones (Premium only)"
  type        = list(string)
  default     = null
}

variable "redis_shard_count" {
  description = "Clustering shard count (Premium only)"
  type        = number
  default     = null
}

variable "redis_rdb_backup_enabled" {
  type        = bool
  default     = false
}

variable "redis_rdb_backup_frequency" {
  description = "Backup frequency in minutes"
  type        = number
  default     = null
}

variable "redis_rdb_storage_connection_string" {
  description = "Storage connection string for RDB backup"
  type        = string
  default     = null
}

variable "redis_subnet_id" {
  description = "Subnet for Premium Redis Cache"
  type        = string
  default     = null
}

variable "redis_tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
#---------------------------
# CDN MODULE VARIABLES
#---------------------------

variable "cdn_profile_name" {
  description = "Name of the CDN profile"
  type        = string
}

variable "cdn_location" {
  description = "Azure Region"
  type        = string
}

variable "cdn_pricing_tier" {
  description = <<EOF
Available CDN SKU options:
- Standard_Verizon
- Premium_Verizon
- Standard_Akamai
- Standard_Microsoft  (Recommended)
EOF
  type = string
}

variable "cdn_tags" {
  description = "Tags to assign to the CDN profile"
  type        = map(string)
  default     = {}
}
############################
# DISK ENCRYPTION SET (DES) VARIABLES
############################

variable "des_key_vault_key_id" {
  description = "The full resource id of the Key Vault key to be used by the Disk Encryption Set."
  type        = string
}

variable "des_key_vault_resource_id" {
  description = "The resource id of the Key Vault (or Managed HSM) that contains the key."
  type        = string
}

variable "des_location" {
  description = "Azure location to deploy the Disk Encryption Set into."
  type        = string
}

variable "des_name" {
  description = "Name of the Disk Encryption Set resource."
  type        = string
}

variable "des_auto_key_rotation_enabled" {
  description = "Enable automatic key rotation for the Disk Encryption Set."
  type        = bool
  default     = false
}

variable "des_enable_telemetry" {
  description = "Enable telemetry/usage reporting via modtm provider."
  type        = bool
  default     = true
}

variable "des_encryption_type" {
  description = "Type of encryption for the Disk Encryption Set."
  type        = string
  default     = "EncryptionAtRestWithCustomerKey"
}

variable "des_federated_client_id" {
  description = "(Optional) Principal id (managed identity or service principal) that should be granted access to the key."
  type        = string
  default     = null
}

variable "des_managed_hsm_key_id" {
  description = "(Optional) Managed HSM key id, if using Managed HSM rather than Key Vault."
  type        = string
  default     = null
}

variable "des_lock" {
  description = <<EOF
Optional management lock object. Set to null to skip creating a lock.
If provided it must contain:
  - kind = "CanNotDelete" | "ReadOnly"
  - name = (optional) lock name. If omitted a default name will be used.
EOF
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "des_tags" {
  description = "Optional tags to apply to resources."
  type        = map(string)
  default     = {}
}


#---------------------------
# AUTOSCALE MODULE VARIABLES
#---------------------------

variable "autoscale_location" {
  description = "Location for metadata (not the target resource)."
  type        = string
}

variable "autoscale_name" {
  description = "Name of the autoscale setting resource."
  type        = string
}

variable "autoscale_target_resource_id" {
  description = "The resource ID of the scalable resource to attach autoscale to."
  type        = string
}

variable "autoscale_profiles" {
  description = "Map of autoscale profiles."
  type = map(object({
    name     = string
    capacity = object({
      default = number
      maximum = number
      minimum = number
    })

    # Scaling rules (optional)
    rules = optional(
      list(object({
        metric_trigger = object({
          metric_name        = string
          metric_resource_id = string
          operator           = string
          statistic          = string
          time_aggregation   = string
          time_grain         = string
          time_window        = string
          threshold          = number
          metric_namespace   = optional(string)
          divide_by_instance_count = optional(bool)
        })

        scale_action = object({
          cooldown  = string
          direction = string
          type      = string
          value     = string
        })
      })),
      [] # Default empty list if rules not provided
    )

    # Optional fixed date scaling
    fixed_date = optional(object({
      start    = string
      end      = string
      timezone = optional(string, "UTC")
    }))

    # Optional recurrence (weekly/daily schedule)
    recurrence = optional(object({
      timezone = optional(string, "UTC")
      days     = list(string)
      hours    = list(number)
      minutes  = list(number)
    }))
  }))
}

variable "autoscale_enable_telemetry" {
  description = "Enable telemetry (handled via null_resource)."
  type        = bool
  default     = true
}

variable "autoscale_enabled" {
  description = "Whether autoscale setting is enabled."
  type        = bool
  default     = true
}

variable "autoscale_notification" {
  description = "Notification block for autoscale (email/webhooks)."
  type = object({
    email = optional(object({
      send_to_subscription_administrator    = optional(bool, false)
      send_to_subscription_co_administrator = optional(bool, false)
      custom_emails                         = optional(list(string), [])
    }))
    webhooks = optional(
      list(object({
        service_uri = string
        properties  = optional(map(string), {})
      })),
      []
    )
  })
  nullable = true
  default  = null
}

variable "autoscale_predictive" {
  description = "Predictive autoscale configuration (optional)."
  type = object({
    scale_mode      = string
    look_ahead_time = optional(string)
  })
  nullable = true
  default  = null
}

variable "autoscale_tags" {
  description = "Tags to assign to the autoscale setting."
  type        = map(string)
  nullable    = true
  default     = {}
}


#---------------------------
# app_service_plan
#---------------------------
variable "app_service_plan_name" {
  type        = string
  description = "Name of the App Service Plan."
}

variable "app_service_plan_location" {
  type        = string
  description = "Azure region for the App Service Plan."
}


variable "app_service_plan_size" {
  type        = string
  description = "SKU name for the App Service Plan (e.g., S1, P1v2)."
  default     = "S1"
}

variable "app_service_plan_os" {
  type        = string
  description = "Operating system for the App Service Plan ('Windows' or 'Linux')."
  default     = "Linux"
}

variable "app_service_plan_tags" {
  type        = map(string)
  description = "Tags for the App Service Plan."
  default     = {}
}

#---------------------------
# azure_cdn_frontdoor
#---------------------------

variable "frontdoor_location" {
  type        = string
  description = "Azure location"
  default     = "East US"
}

variable "frontdoor_custom_name" {
  type        = string
  description = "Custom name for the Front Door"
  default     = ""
}

variable "frontdoor_name_prefix" { type = string }
variable "frontdoor_client_name" { type = string }
variable "frontdoor_environment" { type = string }
variable "frontdoor_stack" { type = string }
variable "frontdoor_name_suffix" { type = string }

variable "frontdoor_sku_name" {
  type        = string
  description = "Front Door SKU (Standard_AzureFrontDoor or Premium_AzureFrontDoor)"
  default     = "Premium_AzureFrontDoor"
}

variable "frontdoor_extra_tags" {
  type        = map(string)
  description = "Tags to attach"
  default     = {}
}

variable "frontdoor_identity" {
  type = map(any)
  default = {
    type = "SystemAssigned"
  }
}

variable "frontdoor_custom_domains" {
  type = list(object({
    name      = string
    host_name = string
    tls = optional(object({
      certificate_type         = optional(string, "ManagedCertificate")
      minimum_tls_version      = optional(string, "TLS12")
      cdn_frontdoor_secret_id  = optional(string, null)
    }), {})
  }))
  default = []

  validation {
    condition = alltrue([
      for d in var.custom_domains :
      (
        d.tls == {} ||
        lookup(d.tls, "minimum_tls_version", "TLS12") != "TLS10"
      )
    ])

    error_message = "TLS10 is deprecated for Azure Front Door. Use TLS12."
  }
}

variable "frontdoor_endpoints" {
  type = list(object({
    name    = string
    enabled = optional(bool, true)
  }))
  default = []
}

variable "frontdoor_origin_groups" {
  type = list(object({
    name                                        = string
    session_affinity_enabled                    = optional(bool, true)
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 10)
    health_probe = optional(object({
      interval_in_seconds = number
      path                = string
      protocol            = string
      request_type        = string
    }))
    load_balancing = optional(object({
      additional_latency_in_milliseconds = number
      sample_size                        = number
      successful_samples_required        = number
    }))
    origins = list(object({
      host_name   = string
      http_port   = optional(number, 80)
      https_port  = optional(number, 443)
      priority    = optional(number, 1)
      weight      = optional(number, 1)
    }))
  }))
  default = []
}

variable "frontdoor_origins" {
  type = list(object({
    name                          = string
    origin_group_name             = string
    host_name                     = string
    http_port                      = optional(number, 80)
    https_port                     = optional(number, 443)
    priority                       = optional(number, 1)
    weight                         = optional(number, 1)
    enabled                        = optional(bool, true)
    certificate_name_check_enabled = optional(bool, true)
  }))
  default = []
}

variable "frontdoor_routes" {
  type = list(object({
    name                   = string
    endpoint_name          = string
    origin_names          = list(string)
    origin_group_name      = string
    forwarding_protocol    = optional(string, "HttpsOnly")
    https_redirect_enabled = optional(bool, true)
    patterns_to_match      = optional(list(string), ["/*"])
    supported_protocols    = optional(list(string), ["Https"])
  }))
  default = []
}

