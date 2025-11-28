variable "autoscale_location" {
  description = "Location for metadata (not the target resource)."
  type        = string
}

variable "autoscale_name" {
  description = "Name of the autoscale setting resource"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which the autoscale setting will exist"
  type        = string
}

variable "autoscale_target_resource_id" {
  description = "The resource id of the scalable resource to attach autoscale to"
  type        = string
}

variable "autoscale_profiles" {
  description = "Map of autoscale profiles"
  type = map(object({
    name     = string
    capacity = object({
      default = number
      maximum = number
      minimum = number
    })
    rules = optional(map(object({
      metric_trigger = object({
        metric_name            = string
        metric_resource_id     = optional(string)
        operator               = string
        statistic              = string
        time_aggregation       = string
        time_grain             = string
        time_window            = string
        threshold              = number
        metric_namespace       = optional(string)
        dimensions             = optional(map(object({
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

variable "autoscale_enable_telemetry" {
  description = "Enable telemetry resource"
  type        = bool
  default     = true
}

variable "autoscale_enabled" {
  description = "Whether autoscale setting is enabled"
  type        = bool
  default     = true
}

variable "autoscale_notification" {
  description = "Notification block for autoscale (email/webhooks)"
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
  description = "Predictive autoscale configuration"
  type        = optional(object({
    scale_mode     = string
    look_ahead_time = optional(string)
  }), null)
  default = null
}

variable "autoscale_tags" {
  description = "Tags"
  type        = optional(map(string), null)
  default     = null
}
