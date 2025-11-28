resource "azurerm_cdn_profile" "one" {
  name                = var.cdn_profile_name
  resource_group_name = var.resource_group_name
  location            = var.cdn_location
  sku                 = var.cdn_pricing_tier

  tags = var.cdn_tags
}
