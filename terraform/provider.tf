provider "google" {
  version = "~> 4.43.0"
  region  = var.region
  project = var.project
}

provider "random" {
  version = "~> 3.4.3"
}

provider "null" {
  version = "~> 3.2.0"
}

provider "kubernetes" {
  version = "~> 2.15.0"
}
