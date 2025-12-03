# 🔐 Azure Disk Encryption Set (DES) — Terraform Module

This Terraform module provisions a fully configured **Azure Disk Encryption Set**, including identity setup, key association (Key Vault or Managed HSM), optional role assignment, and optional management lock.

It follows Azure’s recommended best practices for encrypting Managed Disks using customer-managed keys (CMK).

---

## 🚀 Features

* ✔️ Create an Azure **Disk Encryption Set**
* ✔️ Support for **Key Vault** or **Managed HSM** keys
* ✔️ Automatic fallback logic
  `managed_hsm_key_id > key_vault_key_id`
* ✔️ System-assigned managed identity (required by Azure)
* ✔️ Optional **role assignment** so the DES can access the key
* ✔️ Optional **resource lock** for extra protection
* ✔️ Generates stable UUID for telemetry or naming if needed

---

## 🏗 Architecture Overview

### Resources created:

| Component                         | Purpose                                          |
| --------------------------------- | ------------------------------------------------ |
| `random_uuid.telemetry`           | Generates stable UUID (optional internal use)    |
| `azurerm_disk_encryption_set.one` | Creates the DES resource                         |
| `azurerm_role_assignment.this`    | Assigns access to key (optional)                 |
| `azurerm_management_lock.this`    | Protects DES from accidental deletion (optional) |

### Key Decision Logic:

```
If managed_hsm_key_id is provided → use it  
Else → use key_vault_key_id
```

---

## 📸 Module Flow

1. **Generate UUID** (optional)
2. **Create Disk Encryption Set**

   * Assign system identity
   * Attach CMK from Key Vault or HSM
3. **Assign Key Vault/HSM access** (if federated client ID provided)
4. **Apply Management Lock (optional)**

---

## 🧰 Usage Example (Key Vault)

```hcl
module "des" {
  source = "./modules/des"

  des_name                    = "dev-des"
  des_location                = "East US"
  resource_group_name         = "rg-dev"

  des_key_vault_key_id        = "/subscriptions/.../keys/mykey"
  des_key_vault_resource_id   = "/subscriptions/.../providers/Microsoft.KeyVault/vaults/mykv"

  des_encryption_type         = "EncryptionAtRestWithCustomerKey"
  des_auto_key_rotation_enabled = true

  des_federated_client_id     = "00000000-0000-0000-0000-000000000000"

  des_lock = {
    name = "des-lock"
    kind = "CanNotDelete"
  }

  des_tags = {
    environment = "dev"
    module      = "disk-encryption"
  }
}
```

---

## 🛡 Usage Example (Managed HSM)

```hcl
des_managed_hsm_key_id = "/subscriptions/.../keys/my-hsm-key"
des_key_vault_key_id   = null
```

The module automatically prioritizes the HSM key.

---

## 📥 Inputs (Variables)

| Variable                        | Type   | Description                                    | Required    |
| ------------------------------- | ------ | ---------------------------------------------- | ----------- |
| `des_name`                      | string | Name of the DES                                | Yes         |
| `des_location`                  | string | Azure region                                   | Yes         |
| `resource_group_name`           | string | Resource group                                 | Yes         |
| `des_key_vault_key_id`          | string | Key Vault key ID                               | Conditional |
| `des_managed_hsm_key_id`        | string | Managed HSM key ID                             | Conditional |
| `des_key_vault_resource_id`     | string | KV or HSM resource ID used for role assignment | Conditional |
| `des_encryption_type`           | string | Encryption type (CMK, etc.)                    | Yes         |
| `des_auto_key_rotation_enabled` | bool   | Auto-rotate CMK                                | No          |
| `des_federated_client_id`       | string | Principal ID that needs access to the key      | Optional    |
| `des_lock`                      | object | Optional management lock                       | Optional    |
| `des_tags`                      | map    | Tags                                           | Optional    |

---

## 📤 Outputs

You can expose outputs like:

* DES ID
* Key ID used
* Identity principal ID
* Lock status

(If you'd like, I can generate a full `outputs.tf` for you.)

---

## 🔐 Important Notes

* DES **requires a managed identity** to access your CMK.
* If using Managed HSM, make sure RBAC is enabled.
* Role assignment is **only created if** `des_federated_client_id` is provided.
* When auto-key-rotation is enabled, Azure rotates the CMK every 90 days.
* If deletion protection is required, use the `des_lock` block.

