resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = var.app_service_plan_location
  resource_group_name = var.resource_group_name

  # Determine kind & reserved based on OS
  kind     = var.app_service_plan_os == "Linux" ? "Linux" : "App"
  reserved = var.app_service_plan_os == "Linux" ? true : false

  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }

  tags = var.app_service_plan_tags
}
