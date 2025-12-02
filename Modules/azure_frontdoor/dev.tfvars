resource_group_name = "rg-dev-frontdoor"
location            = "East US"
name_prefix         = "adq"
client_name         = "demo"
environment         = "dev"
stack               = "app"
name_suffix         = "fd"
custom_name         = ""

extra_tags = {
  project = "terraform-frontdoor"
  env     = "dev"
}

custom_domains = [
  {
    name      = "frontend1"
    host_name = "www.example.com"
    tls = {
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    }
  }
]

endpoints = [
  { name = "frontend1-endpoint" }
]

origin_groups = [
  {
    name     = "backend-group-1"
    origins  = [
      { host_name = "app1.internal.cloud" },
      { host_name = "app2.internal.cloud" }
    ]
    health_probe = {
      interval_in_seconds = 30
      path                = "/health"
      protocol            = "Https"
      request_type        = "GET"
    }
    load_balancing = {
      additional_latency_in_milliseconds = 50
      sample_size                        = 4
      successful_samples_required        = 3
    }
    session_affinity_enabled = true
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
  }
]

origins = [
  {
    name              = "origin1"
    origin_group_name = "backend-group-1"
    host_name         = "app1.internal.cloud"
    http_port         = 80
    https_port        = 443
    priority          = 1
    weight            = 1
    enabled           = true
  },
  {
    name              = "origin2"
    origin_group_name = "backend-group-1"
    host_name         = "app2.internal.cloud"
    http_port         = 80
    https_port        = 443
    priority          = 1
    weight            = 1
    enabled           = true
  }
]

routes = [
  {
    name                   = "route1"
    endpoint_name          = "frontend1-endpoint"
    origin_group_name      = "backend-group-1"
    forwarding_protocol    = "HttpsOnly"
    origin_names      = ["origin1", "origin2"]
    https_redirect_enabled = true
    patterns_to_match      = ["/*"]
    accepted_protocols     = ["Https"]
    frontend_endpoints     = ["frontend1"]
  }
]
