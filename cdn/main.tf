resource "google_storage_bucket" "cdn_bucket" {
  name = "cdn_bucket"
  location = "asia-south1"
  storage_class = "MULTI_REGIONAL"
  force_destroy = "true"
  uniform_bucket_level_access = "true"
}

resource "google_storage_bucket_iam_member" "allusers" {
  bucket = "google_storage_bucket.cdn_bucket.name"
  role = "roles/storage.legacyObjectReader"
  member = "allUsers"
}

resource "google_compute_backend_bucket" "cdn_backend_bucket" {
  name = "my_cdn_backend_bucket"
  bucket_name = "google_storage_bucket.cdn_bucket.name"
  enable_cdn = "true"
  project = "project name"
}

resource "google_compute_url_map" "url_map" {
  name = "my_url_map"
  default_service = "google_compute_backend_bucket.cdn_backend_bucket.self_link"
  project = "project name"
  
  default_url_redirect {
    https_redirect = true
    strip_query    = false
}
} 

resource "google_compute_region_target_http_proxy" "http_proxy" {
  name = "my_http_proxy"
  region = "asia-south1"
  url_map = "google_compute_url_map.url_map.id"
  project = "project name"
}

resource "google_compute_global_address" "cdn_public_ip_address" {
  name = "my_cdn_public_ip_address"
  ip_version = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_global_forwarding_rule" "cdn_global_forwarding_rule" {
  name = "my_cdn_global_forwarding_rule"
  target = "google_compute_region_target_http_proxy.http_proxy.self_link"
  ip_address = "google_compute_global_address.cdn_public_ip_address.self_link"
  port_range = ["80","443"]
  project = "project name"
}