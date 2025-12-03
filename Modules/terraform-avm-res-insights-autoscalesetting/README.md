# 📘 Azure Autoscale Terraform Module

This Terraform module creates an **Azure Monitor Autoscale Setting** for App Services, VM Scale Sets, or any Azure resource that supports autoscaling.

It follows **Microsoft’s recommended AVM-style structure**, supports **dynamic notifications**, **multiple profiles**, **custom scaling rules**, and **predictive autoscaling**.

---

## 🚀 Features

* ✔️ Create autoscale settings for any Azure resource
* ✔️ Supports **multiple profiles** (default, scheduled, recurrence-based)
* ✔️ Supports **email + webhook notifications**
* ✔️ Supports **predictive autoscaling** (optional)
* ✔️ Uses dynamic blocks for clean & flexible configuration
* ✔️ Compatible with VMSS, App Services, Function Apps, etc.
* ✔️ Includes optional anonymous telemetry support

---

## 🏗 Module Architecture

This module provisions:

### **1. Autoscale Setting**

`azurerm_monitor_autoscale_setting`
Primary resource defining scale-up/scale-down behavior.

### **2. Notification System**

Optional email/webhook notifications triggered when scaling occurs.

### **3. Autoscale Profiles**

Each profile defines:

* Capacity (min / max / default)
* Schedules (fixed date or recurrence)
* Scaling rules (metric-based)

### **4. Predictive Autoscale**

Optional configuration for:

* Demand forecast–based scaling
* Smart pre-scaling for traffic spikes

### **5. Utility Resources**

* `random_integer` → Used to generate a stable SKU suffix
* `random_uuid` → Used for telemetry
* `null_resource` → Optional telemetry dependency

---

## 📦 Pros & Cons

### ✅ Pros

1. **Standard & Trusted**
   Follows Microsoft’s autoscaling best practices—clean, reliable, and future-proof.

2. **Reusable & Flexible**
   Works across VMSS, App Services, Function Apps, AKS node pools, etc.

---

### ⚠️ Cons

1. **Pre-GA behavior**
   Future provider versions may introduce breaking changes.

2. **Limited deep customization**
   Advanced or highly custom logic must still follow AVM-style structure.

---

## 🔧 Module Usage Example

### **Basic autoscale for App Service Plan**

```hcl
module "autoscale" {
  source = "./modules/autoscale"

  autoscale_name              = "dev-app-autoscale"
  autoscale_location          = "East US"
  resource_group_name         = "rg-dev-app"
  autoscale_target_resource_id = "/subscriptions/<SUB-ID>/resourceGroups/rg-dev-app/providers/Microsoft.Web/serverfarms/dev-appserviceplan"

  autoscale_enabled = true

  autoscale_profiles = {
    default = {
      name = "default-profile"
      capacity = {
        minimum = 1
        maximum = 5
        default = 1
      }
      rules = [
        {
          metric_trigger = {
            metric_name        = "CpuPercentage"
            metric_resource_id = "/subscriptions/<SUB-ID>/..."
            operator           = "GreaterThan"
            statistic          = "Average"
            time_aggregation   = "Average"
            time_grain         = "PT1M"
            time_window        = "PT5M"
            threshold          = 70
          }
          scale_action = {
            direction = "Increase"
            type      = "ChangeCount"
            value     = "1"
            cooldown  = "PT5M"
          }
        }
      ]
    }
  }
}
```

---

## 🔔 Notifications Example

```hcl
autoscale_notification = {
  email = [{
    send_to_subscription_administrator    = false
    send_to_subscription_co_administrator = false
    custom_emails                         = ["alerts@company.com"]
  }]
  webhooks = [{
    service_uri = "https://webhook.site/xyz"
  }]
}
```

---

## 🔮 Predictive Autoscaling Example

```hcl
autoscale_predictive = {
  scale_mode      = "Enabled"
  look_ahead_time = "PT10M"
}
```

---

## 📁 Inputs (Variables)

| Variable                       | Description               | Required | Default |
| ------------------------------ | ------------------------- | -------- | ------- |
| `autoscale_name`               | Autoscale setting name    | Yes      | —       |
| `resource_group_name`          | Resource group            | Yes      | —       |
| `autoscale_target_resource_id` | Resource ID to autoscale  | Yes      | —       |
| `autoscale_location`           | Azure region              | Yes      | —       |
| `autoscale_enabled`            | Enable/disable autoscale  | No       | `true`  |
| `autoscale_profiles`           | Map of autoscale profiles | Yes      | —       |
| `autoscale_notification`       | Email/webhook alerts      | No       | `null`  |
| `autoscale_predictive`         | Predictive config         | No       | `null`  |
| `autoscale_tags`               | Tags                      | No       | `{}`    |
| `autoscale_enable_telemetry`   | Optional telemetry        | No       | `false` |

---

## 📤 Outputs

* Autoscale setting ID
* Profile details
* Notification configuration
* Predictive settings

---

## 🧱 Internal Resources Used

### `azurerm_monitor_autoscale_setting`

Core Azure autoscale resource.

### `dynamic` blocks

Used heavily to allow flexible:

* profiles
* rules
* notifications
* predictive settings

### Random utilities

* `random_integer` → stable SKU suffix
* `random_uuid` → telemetry unique ID
* `null_resource` → optional telemetry dependency

---

## 📝 Notes

* Make sure your metric IDs (`metric_resource_id`) match the resource type.
* Predictive autoscaling is supported only in some SKUs (e.g., App Service Standard/Premium).
* Complex time schedules must follow Azure autoscale rules.

---
