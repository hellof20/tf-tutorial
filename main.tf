variable "access_token" {
    type = string
}

variable "project" {
    type = string
}

resource "random_string" "vm-name" {
  length  = 12
  upper   = false
  number  = false
  lower   = true
  special = false
}

locals {
  vm-name = "${random_string.vm-name.result}-vm"
}

provider "google" {
  project = var.project
  access_token = var.access_token
  region  = "us-central1"
  zone    = "us-central1-c"
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
    network = "default"

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
