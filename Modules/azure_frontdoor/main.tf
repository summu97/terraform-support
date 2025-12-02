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
  host_name                = each.value.host_name
  session_affinity_enabled = lookup(each.value, "session_affinity_enabled", false)

  dynamic "web_application_firewall_policy_link" {
    for_each = each.value.web_application_firewall_policy_link_id != "" ? [1] : []
    content {
      id = each.value.web_application_firewall_policy_link_id
    }
  }
}

# ---------------------------------------------------------
# Origin Groups (1 per backend pool)
# ---------------------------------------------------------
resource "azurerm_cdn_frontdoor_origin_group" "this" {
  for_each = { for pool in var.frontdoor_backend_pools : pool.name => pool }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  session_affinity_enabled = false

  # Required: Load Balancing
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
    additional_latency_in_ms    = 0
  }

  # Health Probe
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
  host_name                     = each.value.backends[0].address
  http_port                     = lookup(each.value.backends[0], "http_port", 80)
  https_port                    = lookup(each.value.backends[0], "https_port", 443)
  priority                       = lookup(each.value.backends[0], "priority", 1)
  weight                         = lookup(each.value.backends[0], "weight", 50)
}

# ---------------------------------------------------------
# Routes (Dynamic Routing Rules)
# ---------------------------------------------------------
resource "azurerm_cdn_frontdoor_route" "this" {
  for_each = { for route in var.frontdoor_routes : route.name => route }

  name = each.value.name

  cdn_frontdoor_endpoint_ids = [
    for fe_name in each.value.frontend_endpoints :
    azurerm_cdn_frontdoor_endpoint.this[fe_name].id
  ]

  cdn_frontdoor_origin_group_id =
    azurerm_cdn_frontdoor_origin_group.this[each.value.forwarding_configuration.backend_pool_name].id

  https_redirect      = true
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

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
