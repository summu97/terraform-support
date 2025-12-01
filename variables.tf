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
    rules = optional(map(object({
      metric_trigger = object({
        metric_name              = string
        metric_resource_id       = optional(string)
        operator                 = string
        statistic                = string
        time_aggregation         = string
        time_grain               = string
        time_window              = string
        threshold                = number
        metric_namespace         = optional(string)
        # Keep as list for dynamic dimension blocks
        dimensions               = optional(list(object({
          name     = string
          operator = string
          values   = list(string)
        })), [])
        divide_by_instance_count = optional(bool)
      }))

      scale_action = object({
        cooldown  = string
        direction = string
        type      = string
        value     = string
      })
    })), {})  # Default empty map if rules not provided

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
    webhooks = optional(list(object({
      service_uri = string
      properties  = optional(map(string), {})
    })), [])
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
variable "app_service_plan_location" {
  description = "app_service_plan Region for resources"
  type        = string
}

variable "app_service_plan_name" {
  type        = string
  description = "Name of the App Service Plan"
}

variable "app_service_plan_tier" {
  type        = string
  description = "Pricing tier (Basic, Standard, Premium)"
}

variable "app_service_plan_size" {
  type        = string
  description = "Instance size (B1, S1, P1v3)"
}

variable "app_service_plan_os_type" {
  type        = string
  description = "OS type to run the plan"
  default     = "Linux"
}

variable "app_service_plan_tags" {
  type        = map(string)
  default     = {}
}

