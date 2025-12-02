# ---------------------------------------------------------
# Front Door Standard/Premium Profile
# ---------------------------------------------------------
resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name            = var.frontdoor_sku
  tags                = var.frontdoor_tags

  lifecycle {
    prevent_destroy = true
  }
}

# ---------------------------------------------------------
# Frontend Endpoints
# ---------------------------------------------------------
resource "azurerm_cdn_frontdoor_endpoint" "this" {
  for_each = { for fe in var.frontend_endpoints : fe.name => fe }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  # host_name removed: automatically assigned
}

# ---------------------------------------------------------
# Origin Groups (1 per backend pool)
# ---------------------------------------------------------
resource "azurerm_cdn_frontdoor_origin_group" "this" {
  for_each = { for pool in var.frontdoor_backend_pools : pool.name => pool }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                 = lookup(each.value.load_balancing_settings, "sample_size", 4)
    successful_samples_required = lookup(each.value.load_balancing_settings, "successful_samples_required", 3)
  }

  health_probe {
    interval_in_seconds = 30
    path                = lookup(each.value, "health_probe_path", "/")
    protocol            = lookup(each.value, "health_probe_protocol", "Https")
  }
}

# ---------------------------------------------------------
# Origins (Backends inside each pool)
# ---------------------------------------------------------
resource "azurerm_cdn_frontdoor_origin" "backend" {
  for_each = { for pool in var.frontdoor_backend_pools : pool.name => pool }

  name                          = "${each.value.name}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this[each.key].id

  host_name                       = each.value.backends[0].address
  http_port                       = lookup(each.value.backends[0], "http_port", 80)
  https_port                      = lookup(each.value.backends[0], "https_port", 443)
  priority                         = lookup(each.value.backends[0], "priority", 1)
  weight                           = lookup(each.value.backends[0], "weight", 50)
  certificate_name_check_enabled   = true
}

# ---------------------------------------------------------
# Routes (Dynamic Routing Rules)
# ---------------------------------------------------------
resource "azurerm_cdn_frontdoor_route" "this" {
  for_each = { for route in var.frontdoor_routes : route.name => route }

  name = each.value.name

  cdn_frontdoor_endpoint_id = azurerm_cdn_frontdoor_endpoint.this[each.value.frontend_endpoints[0]].id
  cdn_frontdoor_origin_ids  = [azurerm_cdn_frontdoor_origin.backend[each.value.forwarding_configuration.backend_pool_name].id]

  supported_protocols = each.value.accepted_protocols
  patterns_to_match   = each.value.patterns_to_match
  forwarding_protocol = "MatchRequest"

  dynamic "cache" {
    for_each = lookup(each.value.forwarding_configuration, "cache_configuration", {}) != {} ? [1] : []
    content {
      query_string_caching_behavior = lookup(each.value.forwarding_configuration.cache_configuration, "query_behavior", "IgnoreQueryString")
    }
  }

  link_to_default_domain = true
  enabled                = true
}

# ---------------------------------------------------------
# Diagnostic Settings (Optional)
# ---------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.frontdoor_diagnostic_log_analytics_workspace_id != "" ? 1 : 0

  name                       = "${var.frontdoor_name}-diag"
  target_resource_id         = azurerm_cdn_frontdoor_profile.this.id
  log_analytics_workspace_id = var.frontdoor_diagnostic_log_analytics_workspace_id

  enabled_log {
    category = "FrontdoorAccessLog"
  }

  enabled_metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}
