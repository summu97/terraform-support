# Terraform Modules for Azure Infrastructure

This repository contains multiple reusable Terraform modules for Azure resources:

- Redis Cache
- CDN Profile
- Disk Encryption Set
- Autoscale Setting

Each module is independent and can be run individually.

---

## Prerequisites

- Terraform >= 1.3.0
- Azure CLI or Service Principal configured
- Appropriate permissions in Azure subscription

---

## How to Run Each Module

### 1. Redis Cache Module

```bash
terraform init
terraform plan -var-file="env/dev.tfvars" -target=module.redis_cache
terraform apply -var-file="env/dev.tfvars" -target=module.redis_cache
