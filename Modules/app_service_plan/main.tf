resource "azurerm_app_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = var.app_service_plan_location
  resource_group_name = var.resource_group_name

  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }

  os_type = var.app_service_plan_os_type
  tags    = var.app_service_plan_tags
}
