output "resource" {
  description = "The full Disk Encryption Set resource object."
  value       = azurerm_disk_encryption_set.one
}

output "resource_id" {
  description = "The resource id of the Disk Encryption Set."
  value       = azurerm_disk_encryption_set.one.id
}
