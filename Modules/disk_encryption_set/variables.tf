variable "des_key_vault_key_id" {
  description = "The full resource id of the Key Vault key to be used by the Disk Encryption Set."
  type        = string
}

variable "des_key_vault_resource_id" {
  description = "The resource id of the Key Vault (or Managed HSM) that contains the key."
  type        = string
}

variable "des_location" {
  description = "Azure location to deploy the Disk Encryption Set into."
  type        = string
}

variable "des_name" {
  description = "Name of the Disk Encryption Set resource."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the Disk Encryption Set will be created."
  type        = string
}

variable "des_auto_key_rotation_enabled" {
  description = "Enable automatic key rotation for the Disk Encryption Set."
  type        = bool
  default     = false
}

variable "des_enable_telemetry" {
  description = "Enable telemetry/usage reporting via modtm provider."
  type        = bool
  default     = true
}

variable "des_encryption_type" {
  description = "Type of encryption for the Disk Encryption Set."
  type        = string
  default     = "EncryptionAtRestWithCustomerKey"
}

variable "des_federated_client_id" {
  description = "(Optional) Principal id (managed identity or service principal) that should be granted access to the key."
  type        = string
  default     = null
}

variable "des_managed_hsm_key_id" {
  description = "(Optional) Managed HSM key id, if using Managed HSM rather than Key Vault."
  type        = string
  default     = null
}

variable "des_lock" {
  description = <<EOF
Optional management lock object. Set to null to skip creating a lock.
If provided it must contain:
  - kind = "CanNotDelete" | "ReadOnly"
  - name = (optional) lock name. If omitted a default name will be used.
EOF
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "des_tags" {
  description = "Optional tags to apply to resources."
  type        = map(string)
  default     = {}
}
