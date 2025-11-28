variable "app_service_plan_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tier" {
  type = string
}

variable "size" {
  type = string
}

variable "os_type" {
  type    = string
  default = "Linux"
}

variable "app_service_plan_tags" {
  type    = map(string)
  default = {}
}
