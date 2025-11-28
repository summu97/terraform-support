# Azure Redis Cache Terraform Module

This Terraform module creates an **Azure Redis Cache** instance with support for Basic, Standard, and Premium tiers. It includes optional premium features like clustering, persistence, availability zones, and VNet integration.

---

## Features

- Create Redis Cache in a specified resource group and region.
- Supports multiple pricing tiers: `Basic`, `Standard`, `Premium`.
- Premium tier enhancements:
  - Availability Zones
  - Sharding / Clustering
  - Data persistence (RDB backups)
  - Virtual Network integration
- Apply custom tags for resource management.

---

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `redis_name` | DNS name for the Redis Cache | string | - |
| `subscription_id` | Azure Subscription ID | string | - |
| `resource_group_name` | Resource Group for Redis | string | - |
| `location` | Azure Region | string | - |
| `pricing_tier` | Redis pricing tier (`Basic`, `Standard`, `Premium`) | string | - |
| `family` | Redis family type (`C` for Basic/Standard, `P` for Premium) | string | - |
| `capacity` | Capacity SKU (0-6 depending on tier) | number | - |
| `enable_non_ssl_port` | Enable non-SSL port | bool | false |
| `zones` | Availability zones (Premium only) | list(string) | null |
| `shard_count` | Enable clustering for Premium SKU | number | null |
| `rdb_backup_enabled` | Enable RDB backups (Premium only) | bool | false |
| `rdb_backup_frequency` | Frequency in minutes for RDB backups | number | null |
| `rdb_storage_connection_string` | Storage connection string for RDB backups | string | null |
| `subnet_id` | Subnet ID for VNet integration (Premium only) | string | null |
| `tags` | Resource tags | map(string) | `{}` |

---

## Outputs

| Name | Description |
|------|-------------|
| `redis_id` | ID of the Redis Cache instance |
| `redis_hostname` | Hostname of the Redis Cache |
| `redis_port` | Port used to connect to Redis |

---

## Usage Example

```hcl
module "redis_cache" {
  source              = "../modules/redis_cache"
  redis_name          = "my-redis-cache"
  resource_group_name = "rg-demo"
  location            = "East US"
  pricing_tier        = "Premium"
  family              = "P"
  capacity            = 1
  enable_non_ssl_port = false
  zones               = ["1", "2", "3"]
  shard_count         = 2
  rdb_backup_enabled  = true
  rdb_backup_frequency = 60
  rdb_storage_connection_string = "<storage-connection-string>"
  subnet_id           = "<subnet-id>"
  tags = {
    environment = "dev"
    project     = "terraform-demo"
  }
}

