output "key_vault_key_url" {
  description = "The URL of the key in Key Vault / Managed HSM."
  value       = var.managed_hsm_key_id != null ? var.managed_hsm_key_id : var.key_vault_key_id
}

output "resource" {
  description = "The full Disk Encryption Set resource object."
  value       = azurerm_disk_encryption_set.one
}

output "resource_id" {
  description = "The resource id of the Disk Encryption Set."
  value       = azurerm_disk_encryption_set.one.id
}
