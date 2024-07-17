provider "google" {
  project ="var.project"
  region = "var.region"
  credentials = file("key.json")
}
provider "google_beta" {
  project ="var.project"
  region = "var.region"
  credentials = file("key.json")
}
