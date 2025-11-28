# Generate a stable UUID used in telemetry or naming if needed
resource "random_uuid" "telemetry" {}

# Optional telemetry via modtm provider (only created when enabled)
resource "modtm_telemetry" "telemetry" {
  count = var.des_enable_telemetry ? 1 : 0

  # The actual module/provider fields will depend on the modtm provider's schema.
  # Provide a sensible set of attributes; adapt to your organization's modtm usage.
  name       = "disk-encryptionset-${var.des_name}"
  id         = random_uuid.telemetry.result
  environment = var.resource_group_name
  location   = var.des_location
  tags       = var.des_tags
}

# Create Disk Encryption Set
resource "azurerm_disk_encryption_set" "one" {
  name                = var.des_name
  location            = var.des_location
  resource_group_name = var.resource_group_name

  # Either key_vault_key_id or managed_hsm_key_id is used (managed_hsm_key_id takes precedence if provided)
  key_vault_key_id = var.des_managed_hsm_key_id != null ? var.des_managed_hsm_key_id : var.des_key_vault_key_id

  encryption_type = var.des_encryption_type

  auto_key_rotation_enabled = var.des_auto_key_rotation_enabled

  tags = var.des_tags
}

# Assign role on Key Vault (or Managed HSM) to the supplied principal so it can access the key.
# This is conditional: only if federated_client_id is provided.
# The role granted is 'Key Vault Crypto Service Encryption' which is appropriate for disk encryption use-case.

data "azurerm_role_definition" "kv_crypto_service_encryption" {
  name = "Key Vault Crypto Service Encryption"
}

resource "azurerm_role_assignment" "this" {
  count              = var.des_federated_client_id == null ? 0 : 1
  scope              = var.des_key_vault_resource_id
  role_definition_id = data.azurerm_role_definition.kv_crypto_service_encryption.id
  principal_id       = var.des_federated_client_id
}

# Optional management lock
resource "azurerm_management_lock" "this" {
  count = var.des_lock == null ? 0 : 1

  name       = coalesce(var.des_lock.name, "lock-${var.des_name}")
  scope      = azurerm_disk_encryption_set.this.id
  lock_level = var.des_lock != null ? var.des_lock.kind : null
}
