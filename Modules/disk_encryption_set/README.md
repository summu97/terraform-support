# Azure Disk Encryption Set Terraform Module

This Terraform module creates an **Azure Disk Encryption Set (DES)** with optional telemetry, key access assignment, and management lock. It is designed to follow Microsoft’s recommended design and can be used in a standardized way across multiple environments.

---

## Features

- Create a Disk Encryption Set with a Key Vault or Managed HSM key.
- Optional **telemetry** using the `modtm` provider.
- Conditional **role assignment** to allow a principal to access the key.
- Optional **management lock** to prevent accidental deletion or modification.
- Supports **automatic key rotation**.
- Allows custom **tags** for resource organization.

---

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `key_vault_key_id` | Full resource ID of the Key Vault key to use | string | - |
| `key_vault_resource_id` | Resource ID of the Key Vault or Managed HSM containing the key | string | - |
| `location` | Azure location to deploy the Disk Encryption Set | string | - |
| `name` | Name of the Disk Encryption Set resource | string | - |
| `resource_group_name` | Resource group where the Disk Encryption Set will be created | string | - |
| `auto_key_rotation_enabled` | Enable automatic key rotation | bool | `false` |
| `enable_telemetry` | Enable telemetry/usage reporting via `modtm` provider | bool | `true` |
| `encryption_type` | Type of encryption for the Disk Encryption Set | string | `EncryptionAtRestWithCustomerKey` |
| `federated_client_id` | Optional principal ID granted access to the key | string | `null` |
| `managed_hsm_key_id` | Optional Managed HSM key ID if using HSM instead of Key Vault | string | `null` |
| `lock` | Optional management lock object with `kind` and optional `name` | object | `null` |
| `tags` | Optional tags to apply to the resource | map(string) | `{}` |

---

## Outputs

| Name | Description |
|------|-------------|
| `key_vault_key_url` | URL of the key in Key Vault or Managed HSM |
| `resource` | Full Disk Encryption Set resource object |
| `resource_id` | Resource ID of the Disk Encryption Set |

---

## Usage Example

```hcl
module "disk_encryption_set" {
  source               = "../modules/disk_encryption_set"
  name                 = "my-disk-encryption-set"
  location             = "East US"
  resource_group_name  = "rg-demo"
  key_vault_key_id     = azurerm_key_vault_key.mykey.id
  key_vault_resource_id = azurerm_key_vault.myvault.id
  auto_key_rotation_enabled = true
  enable_telemetry     = true
  tags = {
    environment = "dev"
    project     = "terraform-demo"
  }
}

