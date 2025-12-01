variable "redis_name" {
  description = "DNS name for the Redis Cache"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group for Redis"
  type        = string
}

variable "redis_location" {
  description = "Azure Region"
  type        = string
}

# =======================
# PRICING TIER OPTIONS
# =======================
# Allowed:
# - Basic
# - Standard
# - Premium
# =======================
variable "redis_pricing_tier" {
  description = "Redis pricing tier"
  type        = string
}

# Redis family and capacity
# Basic/Standard: C0, C1, C2...
# Premium: P1, P2...

variable "redis_family" {
  type        = string
  description = "Redis family type (C or P)"
}

variable "redis_capacity" {
  type        = number
  description = "Capacity SKU (0-6 depending on tier)"
}

variable "redis_enable_non_ssl_port" {
  type        = bool
  default     = false
}

# PREMIUM ONLY VARIABLES
variable "redis_zones" {
  description = "Availability zones for Premium Redis"
  type        = list(string)
  default     = null
}

variable "redis_shard_count" {
  description = "Enable clustering for Premium SKU"
  type        = number
  default     = null
}

variable "redis_rdb_backup_enabled" {
  type        = bool
  default     = false
}

variable "redis_rdb_backup_frequency" {
  description = "Frequency in minutes (15-1440)"
  type        = number
  default     = null
}

variable "redis_rdb_storage_connection_string" {
  description = "Storage connection string for RDB backup"
  type        = string
  default     = null
}

variable "redis_subnet_id" {
  description = "Subnet ID for VNet integration (Premium only)"
  type        = string
  default     = null
}

variable "redis_tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
