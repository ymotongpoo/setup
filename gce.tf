// Copyright 2021 Yoshi Yamaguchi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

terraform {
    required_version = ">=1.0.0"

    required_providers {
        google = ">= 3.56.0"
    }
}

provider "google" {
    project = var.project_id
    zone = var.zone
    region = var.region
}
variable "project_id" {
    type = string
    description = "Google Cloud Platform project ID"
    default = "development-215403"
}

variable "region" {
    type = string
    description = "Google Compute Engine region"
    default = "asia-northeast1"
}

variable "zone" {
    type = string
    description = "Google Compute Engine zone"
    default = "asia-northeast1-a"
}

variable "distribution" {
    type = string
    description = "OS distribution"
    default = "debian"
}

variable "os_image" {
    type = map
    description = "Mapping between OS distribution and image source"
    default = {
        "debian": "debian-cloud/debian-10"
        "ubuntu": "ubuntu-os-cloud/ubuntu-2004-lts"
        "arch": "projects/arch-linux-gce/global/images/family/arch"
    }
}

variable "gce_ssh_user" {
    type = string
    description = "username for SSH"
    default = "demo"
}

data "google_secret_manager_secret_version" "terraform_ssh_private_key" {
    provider = google
    secret = "terraform-ssh-private-key"
    version = "1"
}

data "google_secret_manager_secret_version" "terraform_ssh_pub_key" {
    provider = google
    secret = "terraform-ssh-pub-key"
    version = "1"
}


resource "google_compute_firewall" "dev_http" {
    name = "dev-http"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["8080"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["tracability-sample"]
}

resource "google_compute_instance" "template-instance" {
    name = "${var.distribution}-template"
    machine_type = "e2-standard-4"
    zone = var.zone
    tags = ["dev-env"]
    labels = {
        "process" = "template"
    }

    boot_disk {
        initialize_params {
            size = 50
            image = lookup(var.os_image, var.distribution, "debian-cloud/debian-10")
        }
    }

    network_interface {
        network = "default"
        access_config {}
    }

    scheduling {
        automatic_restart = true
    }

    depends_on = [google_compute_firewall.dev_http]

    service_account {
        scopes = ["compute-rw", "logging-write", "monitoring"]
    }

    metadata = {
        block-project-ssh-keys = "true"
        ssh-keys = "${var.gce_ssh_user}:${data.google_secret_manager_secret_version.terraform_ssh_pub_key.secret_data}"
    }

    provisioner "remote-exec" {
        inline = ["echo hello"]
        connection {
            type = "ssh"
            host = self.network_interface[0].access_config[0].nat_ip
            user = var.gce_ssh_user
            private_key = data.google_secret_manager_secret_version.terraform_ssh_private_key.secret_data
        }
    }

    provisioner "local-exec" {
        working_dir = "./ansible/"
        command = <<EOL
        ANSIBLE_HOST_KEY_CHEKING=False ansible-playbook -i hosts/inventory.gcp.yaml ${var.distribution}.yaml
        EOL
    }
}
