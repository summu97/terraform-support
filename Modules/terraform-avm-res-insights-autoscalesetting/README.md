# Azure Autoscale Terraform Module

This Terraform module provisions **Azure Monitor Autoscale Settings** with optional telemetry and notifications. It is designed to be **standard, reusable, and consistent** across environments.

---

## Features

- Create Azure Monitor Autoscale Settings for scalable resources.
- Support for multiple autoscale **profiles**, rules, and metric triggers.
- Optional **email and webhook notifications**.
- Optional **predictive autoscale configuration**.
- Optional **telemetry resource** using `modtm` provider.
- Generates stable IDs via `random_uuid` and `random_integer` for resource uniqueness.

---

## Pros & Cons

**Pros:**
1. Standard & trusted – Follows Microsoft’s recommended design.
2. Reusable – Works for VMSS, App Services, etc., making autoscaling easy across environments.

**Cons:**
1. Not fully stable yet – Some resources are pre-GA; future releases may introduce breaking changes.
2. Limited flexibility – Customization must follow AVM structure.

---

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `location` | Location for metadata (not target resource) | string | - |
| `name` | Name of the autoscale setting resource | string | - |
| `resource_group_name` | Resource group for the autoscale setting | string | - |
| `target_resource_id` | Resource ID of the scalable resource to attach autoscale to | string | - |
| `profiles` | Map of autoscale profiles including capacity, rules, fixed date, and recurrence | map(object) | - |
| `enable_telemetry` | Enable telemetry resource | bool | `true` |
| `enabled` | Whether autoscale setting is enabled | bool | `true` |
| `notification` | Notification block for email/webhooks | object | `null` |
| `predictive` | Predictive autoscale configuration | object | `null` |
| `tags` | Tags to assign to the resource | map(string) | `null` |

---

## Outputs

| Name | Description |
|------|-------------|
| `resource_id` | ID of the autoscale setting |
| `resource_name` | Name of the autoscale setting |
| `resource` | Full autoscale setting resource object |

---

## Usage Example

```hcl
module "autoscale" {
  source               = "../modules/autoscale"
  name                 = "my-autoscale"
  location             = "East US"
  resource_group_name  = "rg-demo"
  target_resource_id   = azurerm_virtual_machine_scale_set.demo.id
  enabled              = true
  enable_telemetry     = true

  profiles = {
    default = {
      name = "default"
      capacity = {
        default = 2
        minimum = 1
        maximum = 5
      }
      rules = {
        scale_up = {
          metric_trigger = {
            metric_name        = "Percentage CPU"
            operator           = "GreaterThan"
            statistic          = "Average"
            time_aggregation   = "Average"
            time_grain         = "PT1M"
            time_window        = "PT5M"
            threshold          = 75
          }
          scale_action = {
            cooldown  = "PT5M"
            direction = "Increase"
            type      = "ChangeCount"
            value     = "1"
          }
        }
      }
    }
  }
}




This README:

- Covers **module purpose, variables, outputs, usage, pros/cons**.  
- Includes a **realistic HCL usage example**.  
- Is developer-friendly and avoids any unnecessary explanation.  

I can also generate **a matching README for all your modules** (Redis, CDN, Disk Encryption Set, Autoscale) in a **single unified README** if you want.  

Do you want me to do that?

