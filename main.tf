variable "access_token" {
    type = string
}

variable "project_id" {
    type = string
}

variable "network" {
    type = string
}

resource "random_string" "vm-name" {
  length  = 12
  upper   = false
  numeric  = false
  lower   = true
  special = false
}

locals {
  vm-name = "${random_string.vm-name.result}-vm"
}

provider "google" {
  project = var.project_id
  access_token = var.access_token
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_dependent_services = true
}

resource "google_compute_instance" "default" {
  name         = local.vm-name
  machine_type = "f1-micro"
  tags         = ["ssh"]

  metadata = {
    enable-oslogin = "TRUE"
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20220204"
    }
  }

  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  network_interface {
    network = var.network

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
