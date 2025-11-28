# Azure Terraform Modules

This repository contains reusable Terraform modules for deploying Azure resources:

- Redis Cache
- CDN Profile
- Disk Encryption Set
- Autoscale Setting

Modules are independent but can be orchestrated together through `main.tf`.

---

## Prerequisites

- Terraform >= 1.3.0
- Azure CLI or Service Principal configured
- Proper permissions in Azure subscription
- `.tfvars` files for environment-specific variables

---

## How to Run Each Module Individually

### 1. Redis Cache

```bash
terraform init
terraform plan -var-file="env/dev.tfvars" -target=module.azure_redis_cache
terraform apply -var-file="env/dev.tfvars" -target=module.azure_redis_cache
