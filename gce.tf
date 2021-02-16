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

variable "project_id" {
    type = string
    description = "Google Cloud Platform project ID"
    default = "development-215403"
}

variable "region" {
    type = string
    description = "Google Compute Engine region"
    default = "asia-northeast2"
}

variable "zone" {
    type = string
    description = "Google Compute Engine zone"
    default = "asia-northeast2-a"
}

provider "google" {
    project = var.project_id
    zone = var.zone
    region = var.region
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

resource "google_compute_instance" "debian10" {
    name = "dev"
    machine_type = "e2-standard-2"
    zone = var.zone
    tags = ["dev-env"]

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-10"
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

    provisioner "local-exec" {
        working_dir = "./ansible/"
        command = <<EOL
        ansible-playbook -i hosts/inventory.gcp.yaml debian.yaml
        EOL
    }
}

resource "google_compute_instance" "arch_dev" {
    name = "dev"
    machine_type = "e2-standard-2"
    zone = var.zone
    tags = ["dev-env"]

    boot_disk {
        initialize_params {
            image = "arch/arch-linux-gce"
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

    provisioner "local-exec" {
        working_dir = "./ansible/"
        command = <<EOL
        ansible-playbook -i hosts/inventory.gcp.yaml arch.yaml
        EOL
    }
}