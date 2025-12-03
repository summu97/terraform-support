#  Azure App Service Plan Terraform Module

This module creates an **Azure App Service Plan** that can host Web Apps, Function Apps, API Apps, and other App Service–based workloads.

It is designed to be **simple, reusable, and easy to understand**, making it suitable for both small projects and large enterprise environments.

---

## 🌟 Features

### ✔️ Creates an App Service Plan (Linux or Windows)

Supports configuring:

* OS Type (`Linux` / `Windows`)
* SKU / Pricing Tier (e.g., `F1`, `B1`, `S1`, `P1v3`)
* Location
* Tags

---

### ✔️ Fully Parameterized

Everything is configurable through variables:

* Plan name
* OS type
* Pricing SKU
* Region
* Tags

This makes it easy to deploy plans across **DEV, QA, UAT, PROD** environments.

---

## 📦 What This Module Deploys

| Azure Resource       | Terraform Resource     |
| -------------------- | ---------------------- |
| **App Service Plan** | `azurerm_service_plan` |

---

## 🧠 Architecture Overview

```
 ┌──────────────────────────┐
 │    App Service Plan      │
 │ (Linux or Windows)       │
 └──────────────┬───────────┘
                │
     Hosts any number of:
   ┌──────────────────────────┐
   │ Web Apps / Function Apps │
   └──────────────────────────┘
```

The App Service Plan defines the **compute resources**, and any App Service inside it will share the same capacity and scaling configuration.

---

## 🛠️ Example Usage

### **Basic Example**

```hcl
module "asp" {
  source = "./modules/app_service_plan"

  resource_group_name         = "rg-dev-app"
  app_service_plan_name       = "dev-asp"
  app_service_plan_location   = "East US"
  app_service_plan_os         = "Linux"
  app_service_plan_size       = "S1"   # Pricing tier
  app_service_plan_tags       = {
    environment = "dev"
    owner       = "team-app"
  }
}
```

---

## 📘 Input Variables Summary

### **Required Inputs**

| Variable                    | Type   | Description                                      |
| --------------------------- | ------ | ------------------------------------------------ |
| `resource_group_name`       | string | Resource group in which the plan will be created |
| `app_service_plan_name`     | string | Name of the App Service Plan                     |
| `app_service_plan_location` | string | Azure region                                     |
| `app_service_plan_os`       | string | OS type (`Linux` or `Windows`)                   |
| `app_service_plan_size`     | string | SKU / pricing tier                               |

---

### **Optional Inputs**

| Variable                | Type        | Description                              |
| ----------------------- | ----------- | ---------------------------------------- |
| `app_service_plan_tags` | map(string) | Tags applied to the plan (default: `{}`) |

---

## 📤 Outputs

(If you want I can generate `outputs.tf` for these.)

Common outputs include:

* Plan ID
* Plan Name
* Plan Location
* Resource Group

---

## 📝 Notes & Best Practices

* For **Linux plans**, ensure your App Service also uses a Linux-compatible runtime stack.
* For **production workloads**, consider Premium SKU (`P1v3`, `P2v3`, …).
* Scaling (manual or autoscale) is configured **separately**, not in this module.
* App Service Plans are **regional**, not global.
* You can host **multiple apps** inside one plan—only do this when they share the same compute profile.


