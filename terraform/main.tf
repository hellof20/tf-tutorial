terraform {
  backend "consul" {}  
}

variable "project_id" {
    type = string
}

variable "network" {
    type = string
}

variable "subnetwork" {
    type = string
}

variable "vm_name" {
    type = string
}

variable "zone" {
    type = string
}

# resource "random_string" "vm-name" {
#   length  = 12
#   upper   = false
#   numeric  = false
#   lower   = true
#   special = false
# }

# locals {
#   vm-name = "${random_string.vm-name.result}-vm"
# }

provider "google" {
  project = var.project_id
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
  disable_on_destroy = false
}

resource "google_compute_instance" "default" {
  depends_on = [google_project_service.compute]
#   name         = local.vm-name
  name         = var.vm_name
  machine_type = "f1-micro"
  zone = var.zone
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
    subnetwork = var.subnetwork
    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
