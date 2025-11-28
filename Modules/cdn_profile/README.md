# Azure CDN Profile Terraform Module

This Terraform module creates an **Azure CDN Profile** with customizable SKU, location, and tags. It is designed for easy reuse across multiple environments.

---

## Features

- Create a CDN Profile in a specified resource group and region.
- Supports multiple CDN SKUs: `Standard_Verizon`, `Premium_Verizon`, `Standard_Akamai`, `Standard_Microsoft` (recommended).
- Apply custom tags to organize resources.

---

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `cdn_profile_name` | Name of the CDN profile | string | - |
| `subscription_id` | Azure Subscription ID | string | - |
| `resource_group_name` | Resource group where the CDN profile will be created | string | - |
| `location` | Azure region for the CDN profile | string | `East US` |
| `pricing_tier` | CDN SKU. Options: `Standard_Verizon`, `Premium_Verizon`, `Standard_Akamai`, `Standard_Microsoft` | string | - |
| `tags` | Tags to assign to the CDN profile | map(string) | `{}` |

---

## Outputs

| Name | Description |
|------|-------------|
| `cdn_profile_id` | ID of the CDN profile |
| `cdn_profile_name` | Name of the CDN profile |

---

## Usage Example

```hcl
module "cdn_profile" {
  source              = "../modules/cdn_profile"
  cdn_profile_name    = "my-cdn-profile"
  resource_group_name = "rg-demo"
  location            = "East US"
  pricing_tier        = "Standard_Microsoft"
  tags = {
    environment = "dev"
    project     = "terraform-demo"
  }
}

