# Create CDN Front Door Profile (Standard/Premium)
resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name                 = var.frontdoor_sku
  tags                = var.frontdoor_tags

  # recommended lifecycle rule to avoid accidental deletion
  lifecycle {
    prevent_destroy = true
  }
}

# Frontdoor endpoint (the actual routing endpoint)
resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                = "${var.frontdoor_name}-endpoint"
  profile_name        = azurerm_cdn_frontdoor_profile.this.name
  resource_group_name = var.resource_group_name
  origin_host_header  = "" # left blank to use backend host header, can be overridden in backend config
  origin_path         = ""

  dynamic "origin" {
    for_each = var.frontdoor_backend_pools
    content {
      name = origin.value.name
      host_name = origin.value.backends[0].address
      http_port  = origin.value.backends[0].http_port
      https_port = origin.value.backends[0].https_port
      priority   = origin.value.backends[0].priority
      weight     = origin.value.backends[0].weight
      # additional origins can be created separately using azurerm_cdn_frontdoor_custom_domain / origin groups,
      # but the CDN endpoint resource supports multiple origin blocks as needed.
    }
  }

  dynamic "routing_rule" {
    for_each = var.frontdoor_routes
    content {
      name = routing_rule.value.name
      accepted_protocols = routing_rule.value.accepted_protocols
      patterns_to_match  = routing_rule.value.patterns_to_match

      # Forwarding configuration
      forwarding_configuration {
        forwarding_protocol = "MatchRequest"
        # configure cache / custom path via forwarding_configuration fields if needed
      }

      origin_group = lookup(routing_rule.value.forwarding_configuration, "backend_pool_name", null)
    }
  }

  depends_on = [azurerm_cdn_frontdoor_profile.this]
}

# If frontend custom domains or HTTPS config is required, recommend adding resources externally:
# azurerm_cdn_frontdoor_custom_domain and azurerm_cdn_frontdoor_custom_domain_https_configuration
# (not included here to avoid handling certificate source complexity in the module)

# Optional diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "this" {
  count = length(var.frontdoor_diagnostic_log_analytics_workspace_id) > 0 ? 1 : 0

  name               = "${var.frontdoor_name}-diag"
  target_resource_id = azurerm_cdn_frontdoor_profile.this.id
  log_analytics_workspace_id = var.frontdoor_diagnostic_log_analytics_workspace_id

  log {
    category = "FrontdoorAccessLog"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
}
