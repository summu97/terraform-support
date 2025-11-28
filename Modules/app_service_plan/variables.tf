variable "app_service_plan_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "app_service_plan_location" {
  type = string
}

variable "app_service_plan_tier" {
  type = string
}

variable "app_service_plan_size" {
  type = string
}

variable "app_service_plan_os_type" {
  type    = string
  default = "Linux"
}

variable "app_service_plan_tags" {
  type    = map(string)
  default = {}
}
