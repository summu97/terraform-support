variable "cdn_profile_name" {
  description = "The name of the CDN profile"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where CDN profile will be created"
  type        = string
}

variable "cdn_location" {
  description = "Azure region for the CDN profile"
  type        = string
  default     = "East US"
}

variable "cdn_pricing_tier" {
  description = <<EOF
Available CDN SKU options:
- Standard_Verizon
- Premium_Verizon
- Standard_Akamai
- Standard_Microsoft  (Recommended)
EOF
  type = string
}

variable "cdn_tags" {
  description = "Tags to assign to the CDN profile"
  type        = map(string)
  default     = {}
}
