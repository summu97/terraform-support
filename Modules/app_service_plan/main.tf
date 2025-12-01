resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = var.app_service_plan_location
  resource_group_name = var.resource_group_name

  # Required arguments for azurerm_service_plan
  sku_name = var.app_service_plan_size     # e.g., "S1", "P1v2"
  sku_tier = var.app_service_plan_tier     # e.g., "Standard", "Premium"
  os_type  = var.app_service_plan_os       # "Linux" or "Windows"

  # Optional: kind & reserved are inferred from os_type
  kind     = var.app_service_plan_os == "Linux" ? "Linux" : "App"
  reserved = var.app_service_plan_os == "Linux" ? true : false

  tags = var.app_service_plan_tags
}
