variable "app_service_plan_name" {
  type        = string
  description = "Name of the App Service Plan."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "app_service_plan_location" {
  type        = string
  description = "Azure region for the App Service Plan."
}

variable "app_service_plan_tier" {
  type        = string
  description = "Pricing tier for the App Service Plan (e.g., Standard, Premium)."
}

variable "app_service_plan_size" {
  type        = string
  description = "Size for the App Service Plan (e.g., S1, P1v2)."
}

variable "app_service_plan_os" {
  type        = string
  description = "Operating system for the App Service Plan ('Windows' or 'Linux')."
  default     = "Linux"
}

variable "app_service_plan_tags" {
  type        = map(string)
  description = "Tags for the App Service Plan."
  default     = {}
}
