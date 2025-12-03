variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure location"
  default     = "East US"
}

variable "custom_name" {
  type        = string
  description = "Custom name for the Front Door"
  default     = ""
}

variable "name_prefix" { type = string }
variable "client_name" { type = string }
variable "environment" { type = string }
variable "stack" { type = string }
variable "name_suffix" { type = string }

variable "sku_name" {
  type        = string
  description = "Front Door SKU (Standard_AzureFrontDoor or Premium_AzureFrontDoor)"
  default     = "Premium_AzureFrontDoor"
}

variable "extra_tags" {
  type        = map(string)
  description = "Tags to attach"
  default     = {}
}

variable "identity" {
  type = map(any)
  default = {
    type = "SystemAssigned"
  }
}

variable "custom_domains" {
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

variable "endpoints" {
  type = list(object({
    name    = string
    enabled = optional(bool, true)
  }))
  default = []
}

variable "origin_groups" {
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

variable "origins" {
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

variable "routes" {
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
