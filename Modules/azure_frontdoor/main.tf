# ---------------------------------------------------------
# Front Door Standard/Premium Profile
# ---------------------------------------------------------
resource "azurerm_frontdoor" "this" {
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
resource "azurerm_frontdoor_frontend_endpoint" "this" {
  for_each = { for fe in var.frontend_endpoints : fe.name => fe }

  name           = each.value.name
  frontdoor_id   = azurerm_frontdoor.this.id
  host_name      = each.value.host_name
  session_affinity_enabled = false
}

# ---------------------------------------------------------
# Backend Pools
# ---------------------------------------------------------
resource "azurerm_frontdoor_backend_pool" "this" {
  for_each = { for pool in var.frontdoor_backend_pools : pool.name => pool }

  name         = each.value.name
  frontdoor_id = azurerm_frontdoor.this.id
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
resource "azurerm_frontdoor_backend" "this" {
  for_each = { for pool in var.frontdoor_backend_pools : pool.name => pool }

  name                = "${each.value.name}-backend"
  backend_pool_name   = azurerm_frontdoor_backend_pool.this[each.key].name
  frontdoor_id        = azurerm_frontdoor.this.id
  host_name           = each.value.backends[0].address
  http_port           = lookup(each.value.backends[0], "http_port", 80)
  https_port          = lookup(each.value.backends[0], "https_port", 443)
  priority            = lookup(each.value.backends[0], "priority", 1)
  weight              = lookup(each.value.backends[0], "weight", 50)
  host_header         = lookup(each.value.backends[0], "host_header", each.value.backends[0].address)
  enabled             = true
  certificate_name_check_enabled = true
}

# ---------------------------------------------------------
# Routing Rules
# ---------------------------------------------------------
resource "azurerm_frontdoor_routing_rule" "this" {
  for_each = { for route in var.frontdoor_routes : route.name => route }

  name                   = each.value.name
  frontdoor_id           = azurerm_frontdoor.this.id
  frontend_endpoints     = [for fe in each.value.frontend_endpoints : azurerm_frontdoor_frontend_endpoint.this[fe].name]
  accepted_protocols     = each.value.accepted_protocols
  patterns_to_match      = each.value.patterns_to_match
  forwarding_configuration {
    forwarding_protocol = "MatchRequest"
    backend_pool_name   = each.value.forwarding_configuration.backend_pool_name
    cache_configuration {
      query_string_caching_behavior = lookup(each.value.forwarding_configuration.cache_configuration, "query_behavior", "IgnoreQueryString")
    }
    custom_forwarding_path = lookup(each.value.forwarding_configuration, "custom_forwarding_path", "")
  }

  enabled                = true
  link_to_default_domain = true
}

# ---------------------------------------------------------
# Diagnostic Settings (Optional)
# ---------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.frontdoor_diagnostic_log_analytics_workspace_id != "" ? 1 : 0

  name                       = "${var.frontdoor_name}-diag"
  target_resource_id         = azurerm_frontdoor.this.id
  log_analytics_workspace_id = var.frontdoor_diagnostic_log_analytics_workspace_id

  enabled_log {
    category = "FrontdoorAccessLog"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
