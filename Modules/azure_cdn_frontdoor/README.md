#  Azure Front Door (Standard/Premium) Terraform Module

This module deploys a full **Azure Front Door Standard/Premium** configuration including:

* Front Door **Profile**
* **Custom Domains**
* **Endpoints**
* **Origin Groups**
* **Origins**
* **Routes**

It supports simple setups as well as full enterprise-level traffic routing architectures.

The module is fully dynamic and allows you to define all components through variables, enabling **clean, scalable, multi-environment deployments**.

---

## 🌟 Features

### ✔️ 1. Automatic Naming

The module generates a clean resource name using this pattern:

```
<prefix>-<client>-<environment>-<stack>-<suffix>
```

Or uses a fully custom name if provided.

---

### ✔️ 2. Front Door Profile Creation

Creates an Azure Front Door Standard/Premium profile with optional identity:

```hcl
identity {
  type = "SystemAssigned" | "UserAssigned"
}
```

---

### ✔️ 3. Custom Domains

Supports unlimited domains:

* `ManagedCertificate`
* Custom certificates (`cdn_frontdoor_secret_id`)
* TLS versions (default: `TLS12`)

---

### ✔️ 4. Endpoints

Each endpoint can be individually enabled/disabled.

---

### ✔️ 5. Origin Groups

Supports:

* Session affinity
* Health probes
* Load balancing settings

---

### ✔️ 6. Origins

Define all backends with:

* hostname
* http/https ports
* weight
* priority
* origin group mapping

---

### ✔️ 7. Routes

Supports:

* Multi-origin routing
* Path patterns
* HTTPS redirect
* Https-only forwarding
* Endpoint-to-origin-group association

---

## 🧠 Architecture Diagram (Conceptual)

```
          ┌──────────────────────────┐
          │   Front Door Profile     │
          └──────────────┬───────────┘
                         │
     ┌───────────────────┼────────────────────┐
     │                   │                    │
┌─────────┐       ┌────────────┐        ┌────────────┐
│Domains  │       │ Endpoints  │        │  Routes     │
└────┬────┘       └──────┬─────┘        └──────┬─────┘
     │                   │                    │
     │             Maps to EP → OG → Origins  │
     │                   │                    │
┌────▼─────┐      ┌─────▼──────┐      ┌──────▼────────┐
│ DNS Name │      │  Origin     │      │ Patterns, TLS │
└──────────┘      │  Groups     │      └───────────────┘
                  └──────┬──────┘
                         │
                      Origins
```

---

## 📦 Module Structure Overview

This module manages:

| Component          | Terraform Resource                    |
| ------------------ | ------------------------------------- |
| **Profile**        | `azurerm_cdn_frontdoor_profile`       |
| **Custom Domains** | `azurerm_cdn_frontdoor_custom_domain` |
| **Endpoints**      | `azurerm_cdn_frontdoor_endpoint`      |
| **Origin Groups**  | `azurerm_cdn_frontdoor_origin_group`  |
| **Origins**        | `azurerm_cdn_frontdoor_origin`        |
| **Routes**         | `azurerm_cdn_frontdoor_route`         |

Everything is driven from variables—no resource duplication required.

---

## 🛠️ How to Use

### **Example Usage**

```hcl
module "frontdoor" {
  source = "./modules/frontdoor"

  resource_group_name = "rg-dev-apps"

  frontdoor_name_prefix = "fd"
  frontdoor_client_name = "app"
  frontdoor_environment = "dev"
  frontdoor_stack       = "web"

  frontdoor_sku_name = "Standard_AzureFrontDoor"
```

### **Custom Domains Example**

```hcl
  frontdoor_custom_domains = [
    {
      name      = "mydomain"
      host_name = "app.mydomain.com"
      tls = {
        certificate_type    = "ManagedCertificate"
        minimum_tls_version = "TLS12"
      }
    }
  ]
```

### **Endpoints Example**

```hcl
  frontdoor_endpoints = [
    {
      name    = "app-endpoint"
      enabled = true
    }
  ]
```

### **Origin Groups Example**

```hcl
  frontdoor_origin_groups = [
    {
      name = "app-og"
      session_affinity_enabled = true
      health_probe = {
        interval_in_seconds = 30
        path                = "/health"
        protocol            = "Https"
        request_type        = "GET"
      }
      load_balancing = {
        sample_size = 4
      }
    }
  ]
```

### **Origins Example**

```hcl
  frontdoor_origins = [
    {
      name              = "app-origin-1"
      host_name         = "app-backend-1.azurewebsites.net"
      origin_group_name = "app-og"
      https_port        = 443
    }
  ]
```

### **Routes Example**

```hcl
  frontdoor_routes = [
    {
      name             = "app-route"
      endpoint_name    = "app-endpoint"
      origin_group_name = "app-og"
      origin_names      = ["app-origin-1"]
      patterns_to_match = ["/*"]
    }
  ]
}
```

---

## 📘 Input Variables Summary

| Variable Group | Description                                         |
| -------------- | --------------------------------------------------- |
| Naming         | Prefix, client, environment, stack, suffix          |
| Profile        | SKU, identity, tags                                 |
| Custom Domains | Hostname, TLS, certificate                          |
| Endpoints      | Enabled flag                                        |
| Origin Groups  | Health probe, load balancing, session affinity      |
| Origins        | Hostname, ports, weight, priority                   |
| Routes         | Mapping rules, protocols, redirects, route patterns |

If you want, I can generate a full **variables.tf table** as well.

---

## 📝 Notes & Best Practices

* Always ensure your **origin group name** in routes & origins matches exactly.
* TLS10 is deprecated — the module defaults to **TLS12**.
* One Front Door profile can host **multiple microservices** using different endpoints & paths.
* Use `origin_names` to map multiple backend origins for failover or load balancing.

