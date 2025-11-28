resource "azurerm_cdn_profile" "this" {
  name                = var.cdn_profile_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.pricing_tier

  tags = var.tags
}
