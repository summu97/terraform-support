# Azure Terraform Modules

This repository contains reusable Terraform modules for deploying Azure resources:

- app_service_plan
- azure_cdn_frontdoor
- azure_redis_cache
- disk_encryption_set
- terraform-avm-res-insights-autoscalesetting

Modules are independent but can be orchestrated together through `main.tf`.

---

## Prerequisites

- Terraform >= 1.3.0
- Azure CLI or Service Principal configured
- Proper permissions in Azure subscription
- `.tfvars` files for environment-specific variables

---

## How to Run Each Module Individually

### 1. App Service Plan

```bash
terraform init
terraform plan -var-file="Environments/dev.tfvars" -target=module.app_service_plan 
terraform apply -var-file="Environments/dev.tfvars" -target=module.app_service_plan 
```
