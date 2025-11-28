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

variable "location" {
  description = "Azure Region for resources"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}


#---------------------------
# REDIS MODULE VARIABLES
#---------------------------

variable "redis_name" {
  description = "DNS name for the Redis Cache"
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

variable "enable_non_ssl_port" {
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

variable "rdb_backup_enabled" {
  type        = bool
  default     = false
}

variable "rdb_backup_frequency" {
  description = "Backup frequency in minutes"
  type        = number
  default     = null
}

variable "rdb_storage_connection_string" {
  description = "Storage connection string for RDB backup"
  type        = string
  default     = null
}

variable "redis_subnet_id" {
  description = "Subnet for Premium Redis Cache"
  type        = string
  default     = null
}


#---------------------------
# CDN MODULE VARIABLES
#---------------------------

variable "cdn_profile_name" {
  description = "Name of the CDN profile"
  type        = string
}

variable "cdn_pricing_tier" {
  description = "CDN SKU"
  type        = string
}


############################
# DISK ENCRYPTION SET (DES) VARIABLES
############################

variable "des_name" {
  description = "Disk Encryption Set name"
  type        = string
}

variable "key_vault_key_id" {
  description = "Key Vault key ID"
  type        = string
}

variable "key_vault_resource_id" {
  description = "Key Vault/Managed HSM resource ID"
  type        = string
}

variable "auto_key_rotation_enabled" {
  type        = bool
  default     = false
}

variable "enable_telemetry" {
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type"
  type        = string
  default     = "EncryptionAtRestWithCustomerKey"
}

variable "federated_client_id" {
  description = "Principal ID for access"
  type        = string
  default     = null
}

variable "managed_hsm_key_id" {
  type        = string
  default     = null
}

variable "lock" {
  description = "Optional lock configuration"
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}


#---------------------------
# AUTOSCALE MODULE VARIABLES
#---------------------------

variable "autoscale_name" {
  description = "Autoscale resource name"
  type        = string
}

variable "autoscale_target_resource_id" {
  description = "ID of resource to autoscale"
  type        = string
}

variable "autoscale_profiles" {
  description = "Autoscale profiles"
  type = map(object({
    name     = string
    capacity = object({
      default = number
      maximum = number
      minimum = number
    })
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
        dimensions               = optional(map(object({
          name     = string
          operator = string
          values   = list(string)
        })))
        divide_by_instance_count = optional(bool)
      })

      scale_action = object({
        cooldown  = string
        direction = string
        type      = string
        value     = string
      })
    })))
    fixed_date = optional(object({
      end      = string
      start    = string
      timezone = optional(string, "UTC")
    }))
    recurrence = optional(object({
      timezone = optional(string, "UTC")
      days     = list(string)
      hours    = list(number)
      minutes  = list(number)
    }))
  }))
}

variable "autoscale_enabled" {
  type    = bool
  default = true
}

variable "autoscale_notification" {
  description = "Autoscale notification"
  type = optional(object({
    email = optional(object({
      send_to_subscription_administrator     = optional(bool, false)
      send_to_subscription_co_administrator  = optional(bool, false)
      custom_emails                          = optional(list(string), [])
    }))
    webhooks = optional(map(object({
      service_uri = string
      properties  = optional(map(string), {})
    })))
  }), null)
  default = null
}

variable "autoscale_predictive" {
  description = "Predictive autoscale settings"
  type = optional(object({
    scale_mode      = string
    look_ahead_time = optional(string)
  }), null)
  default = null
}
