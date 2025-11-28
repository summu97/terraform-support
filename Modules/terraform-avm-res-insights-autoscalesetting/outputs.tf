output "resource_id" {
  description = "ID of the autoscale setting"
  value       = azurerm_monitor_autoscale_setting.monitor_autoscale_setting.id
}

output "resource_name" {
  description = "Name of the autoscale setting"
  value       = azurerm_monitor_autoscale_setting.monitor_autoscale_setting.name
}

output "resource" {
  description = "Full resource object"
  value       = azurerm_monitor_autoscale_setting.monitor_autoscale_setting
}
