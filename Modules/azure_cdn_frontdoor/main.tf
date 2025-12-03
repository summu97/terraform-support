locals {
  frontdoor_name = var.frontdoor_custom_name != "" ? var.frontdoor_custom_name : join("-", compact([var.frontdoor_name_prefix, var.frontdoor_client_name, var.frontdoor_environment, var.frontdoor_stack, var.frontdoor_name_suffix]))
}

# --------------------------
# Front Door Profile
# --------------------------
resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = local.frontdoor_name
  resource_group_name = var.frontdoor_resource_group_name
  sku_name            = var.frontdoor_sku_name
  tags                = var.frontdoor_extra_tags

  identity {
    type = lookup(var.frontdoor_identity, "type", "SystemAssigned")
  }
}

# --------------------------
# Custom Domains
# --------------------------
resource "azurerm_cdn_frontdoor_custom_domain" "main" {
  for_each                = { for cd in var.frontdoor_custom_domains : cd.name => cd }
  name                    = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  host_name               = each.value.host_name

  tls {
    certificate_type         = lookup(each.value.tls, "certificate_type", "ManagedCertificate")
    minimum_tls_version      = lookup(each.value.tls, "minimum_tls_version", "TLS12")
    cdn_frontdoor_secret_id  = lookup(each.value.tls, "cdn_frontdoor_secret_id", null)
  }
}

# --------------------------
# Endpoints
# --------------------------
resource "azurerm_cdn_frontdoor_endpoint" "main" {
  for_each              = { for ep in var.frontdoor_endpoints : ep.name => ep }
  name                  = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  enabled               = lookup(each.value, "enabled", true)
}

# --------------------------
# Origin Groups
# --------------------------
resource "azurerm_cdn_frontdoor_origin_group" "main" {
  for_each = { for og in var.frontdoor_origin_groups : og.name => og }

  name                         = each.value.name
  cdn_frontdoor_profile_id      = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled      = lookup(each.value, "session_affinity_enabled", true)
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = lookup(each.value, "restore_traffic_time_to_healed_or_new_endpoint_in_minutes", 10)

  dynamic "health_probe" {
    for_each = each.value.health_probe != null ? [each.value.health_probe] : []
    content {
      interval_in_seconds = health_probe.value.interval_in_seconds
      path                = health_probe.value.path
      protocol            = health_probe.value.protocol
      request_type        = health_probe.value.request_type
    }
  }

  dynamic "load_balancing" {
    for_each = each.value.load_balancing != null ? [each.value.load_balancing] : []
    content {
      additional_latency_in_milliseconds = lookup(load_balancing.value, "additional_latency_in_milliseconds", 50)
      sample_size                        = lookup(load_balancing.value, "sample_size", 4)
      successful_samples_required        = lookup(load_balancing.value, "successful_samples_required", 3)
    }
  }
}

# --------------------------
# Origins
# --------------------------
resource "azurerm_cdn_frontdoor_origin" "main" {
  for_each = { for o in var.frontdoor_origins : o.name => o }

  name                           = each.value.name
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.main[each.value.origin_group_name].id
  host_name                      = each.value.host_name
  enabled                        = lookup(each.value, "enabled", true)
  http_port                       = lookup(each.value, "http_port", 80)
  https_port                      = lookup(each.value, "https_port", 443)
  priority                        = lookup(each.value, "priority", 1)
  weight                          = lookup(each.value, "weight", 1)
  certificate_name_check_enabled  = true
}

# --------------------------
# Routes
# --------------------------
resource "azurerm_cdn_frontdoor_route" "main" {
  for_each = { for r in var.frontdoor_routes : r.name => r }

  name                          = each.value.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.main[each.value.origin_group_name].id
  cdn_frontdoor_origin_ids       = [for o in each.value.origin_names : azurerm_cdn_frontdoor_origin.main[o].id]
  cdn_frontdoor_endpoint_id      = azurerm_cdn_frontdoor_endpoint.main[each.value.endpoint_name].id
  supported_protocols            = lookup(each.value, "supported_protocols", ["Https"])
  forwarding_protocol            = lookup(each.value, "forwarding_protocol", "HttpsOnly")
  https_redirect_enabled         = lookup(each.value, "https_redirect_enabled", true)
  patterns_to_match              = lookup(each.value, "patterns_to_match", ["/*"])
}
