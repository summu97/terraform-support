variable "frontdoor_name" {
  description = "Base name for Front Door profile"
  type        = string
}


variable "resource_group_name" {
  description = "Resource Group name to create/use"
  type        = string
}

variable "frontdoor_sku" {
  description = "Front Door SKU: Standard_AzureFrontDoor, Premium_AzureFrontDoor or Standard"
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "frontdoor_tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}

# Frontend endpoints (list of maps)
variable "frontend_endpoints" {
  description = <<EOT
List of frontend endpoints definitions.
Each item:
{
  name                = "frontend1"
  host_name           = "www.example.com"
  session_affinity_enabled = false
  web_application_firewall_policy_link_id = ""  # optional
}
EOT
  type    = list(object({
    name                             = string
    host_name                        = string
    session_affinity_enabled         = optional(bool, false)
    web_application_firewall_policy_link_id = optional(string, "")
  }))
  default = []
}

# Backend pools (list)
variable "frontdoor_backend_pools" {
  description = "Backends and health settings"
  type = list(object({
    name                    = string
    backends = list(object({
      address             = string
      http_port           = optional(number, 80)
      https_port          = optional(number, 443)
      priority            = optional(number, 1)
      weight              = optional(number, 50)
      host_header         = optional(string, "")
    }))
    health_probe_path      = optional(string, "/")
    health_probe_protocol  = optional(string, "Https")
    load_balancing_settings = optional(map(any), {})
  }))
  default = []
}

# Routing rules
variable "frontdoor_routes" {
  description = "Routing rules (link frontends -> backend pools)"
  type = list(object({
    name               = string
    frontend_endpoints = list(string) # names
    accepted_protocols = list(string) # ["Http","Https"]
    patterns_to_match  = list(string) # [ "/*" ]
    forwarding_configuration = object({
      backend_pool_name = string
      cache_configuration = optional(map(any), {})
      custom_forwarding_path = optional(string, "")
    })
  }))
  default = []
}

# Optional: diagnostics / log analytics workspace id
variable "frontdoor_diagnostic_log_analytics_workspace_id" {
  description = "Optional Log Analytics workspace resource id to send diagnostics to"
  type        = string
  default     = ""
}
