# Front Door Standard/Premium Profile
resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name            = var.frontdoor_sku
  tags                = var.frontdoor_tags

  lifecycle {
    prevent_destroy = true
  }
}

# Front Door Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = "${var.frontdoor_name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

# Origin Group
resource "azurerm_cdn_frontdoor_origin_group" "this" {
  name                     = "${var.frontdoor_name}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  session_affinity_enabled = false
}

# Origin (Backend Pool)
resource "azurerm_cdn_frontdoor_origin" "backend" {
  for_each = {
    for backend in var.frontdoor_backend_pools :
    backend.name => backend
  }

  name                            = each.value.name
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.this.id
  host_name                       = each.value.address
  http_port                       = lookup(each.value, "http_port", 80)
  https_port                      = lookup(each.value, "https_port", 443)
  priority                        = lookup(each.value, "priority", 1)
  weight                          = lookup(each.value, "weight", 50)
}

# Routing Rule (Route)
resource "azurerm_cdn_frontdoor_route" "this" {
  name                          = "${var.frontdoor_name}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id

  https_redirect      = true
  supported_protocols = ["Http", "Https"]
  patterns_to_match   = ["/*"]
  forwarding_protocol = "MatchRequest"

  link_to_default_domain = true
  enabled                = true
}

# Diagnostic Settings (Optional)
resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.frontdoor_diagnostic_log_analytics_workspace_id != "" ? 1 : 0

  name                       = "${var.frontdoor_name}-diag"
  target_resource_id         = azurerm_cdn_frontdoor_endpoint.this.id
  log_analytics_workspace_id = var.frontdoor_diagnostic_log_analytics_workspace_id

  enabled_log {
    category = "FrontdoorAccessLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
