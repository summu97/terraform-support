#  Azure Redis Cache Terraform Module

This Terraform module deploys an **Azure Redis Cache** instance and intelligently enables **Premium-tier features only when the selected SKU is Premium**.

It works for all Redis SKUs:

* **Basic**
* **Standard**
* **Premium** (with advanced features)

The module automatically handles feature availability based on the SKU, so the same module can be used for any environment.

---

## ✅ **Features**

### **Basic / Standard**

* Deploys Redis Cache with:

  * Name
  * Location
  * Capacity
  * Family (C, P, etc.)
  * Tags

### **Premium-only Features (Auto-enabled when `redis_pricing_tier = "Premium"`):**

1. **Availability Zones**
2. **Clustering / Sharding (`shard_count`)**
3. **Data Persistence (RDB):**

   * `rdb_backup_enabled`
   * `rdb_backup_frequency`
   * `rdb_storage_connection_string`
4. **VNet Integration using `subnet_id`**

If a non-premium tier is selected, these features are **automatically disabled**.

---

## 📌 **How It Works**

This local variable determines if the selected SKU is Premium:

```hcl
locals {
  is_premium = var.redis_pricing_tier == "Premium"
}
```

Premium-only arguments are applied conditionally:

```hcl
zones        = local.is_premium ? var.redis_zones : null
shard_count  = local.is_premium ? var.redis_shard_count : null
subnet_id    = local.is_premium ? var.redis_subnet_id : null
```

And dynamic persistence config:

```hcl
dynamic "redis_configuration" {
  for_each = local.is_premium ? [1] : []
  content {
    rdb_backup_enabled            = var.redis_rdb_backup_enabled
    rdb_backup_frequency          = var.redis_rdb_backup_frequency
    rdb_storage_connection_string = var.redis_rdb_storage_connection_string
  }
}
```

---

## 📘 **Inputs**

| Variable              | Type        | Description                | Required |
| --------------------- | ----------- | -------------------------- | -------- |
| `redis_name`          | string      | Redis Cache name           | Yes      |
| `redis_location`      | string      | Azure region               | Yes      |
| `resource_group_name` | string      | Resource group             | Yes      |
| `redis_pricing_tier`  | string      | Basic / Standard / Premium | Yes      |
| `redis_capacity`      | number      | Cache size (e.g., 1, 2, 3) | Yes      |
| `redis_family`        | string      | Cache family (C/P)         | Yes      |
| `redis_tags`          | map(string) | Resource tags              | No       |

### **Premium-only Inputs**

| Variable                              | Description                       |
| ------------------------------------- | --------------------------------- |
| `redis_zones`                         | Availability Zones                |
| `redis_shard_count`                   | Number of shards                  |
| `redis_rdb_backup_enabled`            | Enable RDB backups                |
| `redis_rdb_backup_frequency`          | Backup frequency                  |
| `redis_rdb_storage_connection_string` | Storage account connection string |
| `redis_subnet_id`                     | Subnet for VNet injection         |

> These are **ignored automatically** when using a non-premium tier.

---

## 🚀 **Example Usage**

### **Standard Redis**

```hcl
module "redis" {
  source = "./modules/redis"

  redis_name           = "dev-redis"
  redis_location       = "East US"
  resource_group_name  = "rg-dev"
  redis_pricing_tier   = "Standard"
  redis_capacity       = 2
  redis_family         = "C"

  redis_tags = {
    environment = "dev"
  }
}
```

### **Premium Redis (with clustering + RDB backups)**

```hcl
module "redis" {
  source = "./modules/redis"

  redis_name           = "prod-redis"
  redis_location       = "East US"
  resource_group_name  = "rg-prod"
  redis_pricing_tier   = "Premium"
  redis_capacity       = 3
  redis_family         = "P"

  redis_zones          = ["1", "2", "3"]
  redis_shard_count    = 2
  redis_subnet_id      = "/subscriptions/.../subnets/redis-subnet"

  redis_rdb_backup_enabled            = true
  redis_rdb_backup_frequency          = 60
  redis_rdb_storage_connection_string = "DefaultEndpointsProtocol=https;AccountName=xxx;AccountKey=xxx;"

  redis_tags = {
    environment = "prod"
  }
}
```

---

## 📝 **Notes**

* Premium tier is required for:

  * VNet integration
  * Clustering
  * RDB Persistence
  * Zone redundancy
* The module automatically prevents Terraform errors by disabling premium-only fields for non-premium SKUs.
* The same module can be used across **Dev, QA, UAT, and Prod** with different `.tfvars`.


