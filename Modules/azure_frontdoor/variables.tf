# ---------------------------------------------------------
# Front Door Profile – Basic Settings
# ---------------------------------------------------------
variable "frontdoor_name" {
  description = "Name of the Azure Front Door profile."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group in which Front Door will be created."
  type        = string
}

variable "frontdoor_sku" {
  description = "Front Door SKU. Options: Standard_AzureFrontDoor, Premium_AzureFrontDoor."
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "frontdoor_tags" {
  description = "Resource tags applied to the Front Door profile."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------
# Frontend Endpoints
# ---------------------------------------------------------
variable "frontend_endpoints" {
  description = <<EOT
List of Frontend Endpoints.

Each item example:
{
  name      = "frontend1"
  host_name = "www.example.com"
}
EOT

  type = list(object({
    name      = string
    host_name = string
  }))

  default = []
}

# ---------------------------------------------------------
# Backend Pools
# ---------------------------------------------------------
variable "frontdoor_backend_pools" {
  description = "Definition for backend pools and health probe settings."

  type = list(object({
    name = string

    backends = list(object({
      address     = string
      http_port   = optional(number, 80)
      https_port  = optional(number, 443)
      priority    = optional(number, 1)
      weight      = optional(number, 50)
      host_header = optional(string, "")
    }))

    health_probe_path       = optional(string, "/")
    health_probe_protocol   = optional(string, "Https")
    load_balancing_settings = optional(map(any), {
      sample_size                 = 4
      successful_samples_required = 3
    })
  }))

  default = []
}

# ---------------------------------------------------------
# Routes (Link Frontend -> Backend Pool)
# ---------------------------------------------------------
variable "frontdoor_routes" {
  description = "Routing rules mapping frontend endpoints to backend pools."

  type = list(object({
    name               = string
    frontend_endpoints = list(string)        # list of frontend names
    accepted_protocols = list(string)        # e.g., ["Http", "Https"]
    patterns_to_match  = list(string)        # e.g., ["/*"]

    forwarding_configuration = object({
      backend_pool_name      = string
      cache_configuration    = optional(map(any), {})
      custom_forwarding_path = optional(string, "")
    })
  }))

  default = []
}

# ---------------------------------------------------------
# Diagnostics / Logging
# ---------------------------------------------------------
variable "frontdoor_diagnostic_log_analytics_workspace_id" {
  description = "Log Analytics Workspace Resource ID for diagnostic logging (optional)."
  type        = string
  default     = ""
}
