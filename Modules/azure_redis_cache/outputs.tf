output "redis_id" {
  value = azurerm_redis_cache.this.id
}

output "redis_hostname" {
  value = azurerm_redis_cache.this.hostname
}

output "redis_port" {
  value = azurerm_redis_cache.this.port
}
