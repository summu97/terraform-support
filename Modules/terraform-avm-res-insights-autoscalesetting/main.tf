// NOTE: Pros & Cons
// Pros:
// 1) Standard & trusted – Follows Microsoft’s recommended design, so it's reliable and clean.
// 2) Reusable – Works for VMSS, App Services, etc., making autoscaling easy across all environments.
// Cons:
// 1) Not fully stable yet – It’s still pre-GA, so future versions may introduce breaking changes.
// 2) Limited flexibility – You must follow AVM’s structure, so heavy customization can be harder.

resource "random_integer" "deploy_sku" {
  min = 10000
  max = 99999
}

resource "random_uuid" "telemetry" {}

// Optional telemetry resource (modtm)
resource "modtm_telemetry" "telemetry" {
  count = var.autoscale_enable_telemetry ? 1 : 0

  name        = "autoscale-telemetry-${random_uuid.telemetry.result}"
  description = "Telemetry for autoscale setting created by module"
  properties = {
    source  = "terraform-avm-res-insights-autoscalesetting"
    version = "0.1"
  }
}

resource "azurerm_monitor_autoscale_setting" "monitor_autoscale_setting" {
  name                = var.autoscale_name
  resource_group_name = var.resource_group_name
  location            = var.autoscale_location
  target_resource_id  = var.autoscale_target_resource_id
  enabled             = var.autoscale_enabled
  tags                = var.autoscale_autoscale_tags

  dynamic "notification" {
    for_each = var.autoscale_notification == null ? [] : [var.autoscale_notification]
    content {
      dynamic "email" {
        for_each = lookup(notification.value, "email", null) == null ? [] : [lookup(notification.value, "email")]
        content {
          send_to_subscription_administrator    = lookup(email.value, "send_to_subscription_administrator", false)
          send_to_subscription_co_administrator = lookup(email.value, "send_to_subscription_co_administrator", false)
          custom_emails                         = lookup(email.value, "custom_emails", [])
        }
      }

      dynamic "webhook" {
        for_each = lookup(notification.value, "webhooks", {})
        content {
          service_uri = webhook.value.service_uri
          properties  = lookup(webhook.value, "properties", {})
        }
      }
    }
  }

  dynamic "profile" {
    for_each = var.autoscale_profiles
    content {
      name = profile.value.name

      capacity {
        default = profile.value.capacity.default
        minimum = profile.value.capacity.minimum
        maximum = profile.value.capacity.maximum
      }

      dynamic "fixed_date" {
        for_each = contains(keys(profile.value), "fixed_date") ? [profile.value.fixed_date] : []
        content {
          start    = fixed_date.value.start
          end      = fixed_date.value.end
          timezone = lookup(fixed_date.value, "timezone", "UTC")
        }
      }

      dynamic "recurrence" {
        for_each = contains(keys(profile.value), "recurrence") ? [profile.value.recurrence] : []
        content {
          timezone = lookup(recurrence.value, "timezone", "UTC")

          recurrence {
            frequency = "Week"
            // days/hours/minutes mapping
            days    = recurrence.value.days
            hours   = recurrence.value.hours
            minutes = recurrence.value.minutes
          }
        }
      }

      dynamic "rule" {
        for_each = lookup(profile.value, "rules", {})
        content {
          metric_trigger {
            metric_name            = rule.value.metric_trigger.metric_name
            metric_resource_id     = try(rule.value.metric_trigger.metric_resource_id, null)
            operator               = rule.value.metric_trigger.operator
            statistic              = rule.value.metric_trigger.statistic
            time_aggregation       = rule.value.metric_trigger.time_aggregation
            time_grain             = rule.value.metric_trigger.time_grain
            time_window            = rule.value.metric_trigger.time_window
            threshold              = rule.value.metric_trigger.threshold
            metric_namespace       = try(rule.value.metric_trigger.metric_namespace, null)
            divide_by_instance_count = try(rule.value.metric_trigger.divide_by_instance_count, null)

            dynamic "dimension" {
              for_each = try(rule.value.metric_trigger.dimensions, {})
              content {
                name     = dimension.value.name
                operator = dimension.value.operator
                values   = dimension.value.values
              }
            }
          }

          scale_action {
            cooldown  = rule.value.scale_action.cooldown
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
          }
        }
      }
    }
  }

  dynamic "predictive" {
    for_each = var.predictive == null ? [] : [var.predictive]
    content {
      scale_mode     = predictive.value.scale_mode
      look_ahead_time = try(predictive.value.look_ahead_time, null)
    }
  }

  depends_on = var.enable_telemetry ? [modtm_telemetry.telemetry] : []
}
