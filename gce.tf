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

variable "gce_ssh_user" {
    type = string
    description = "username for SSH"
    default = "demo"
}
variable "gce_ssh_pub_key_file" {
    type = string
    description = "path the public key file"
    default = "~/.ssh/gcp_terraform.pub"
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
    name = "debian10"
    machine_type = "e2-standard-4"
    zone = var.zone
    tags = ["dev-env"]

    boot_disk {
        initialize_params {
            size = 50
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

    metadata = {
        block-project-ssh-keys = "true"
        ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
    }

    provisioner "remote-exec" {
        inline = ["echo hello"]
        connection {
            type = "ssh"
            host = self.network_interface[0].access_config[0].nat_ip
            user = var.gce_ssh_user
            private_key = file("~/.ssh/gcp_terraform")
        }
    }

    provisioner "local-exec" {
        working_dir = "./ansible/"
        command = <<EOL
        ANSIBLE_HOST_KEY_CHEKING=False ansible-playbook -i hosts/inventory.gcp.yaml debian.yaml
        EOL
    }
}

resource "google_compute_instance" "ubuntu2004" {
    name = "ubuntu2004"
    machine_type = "e2-standard-4"
    zone = var.zone
    tags = ["dev-env"]

    boot_disk {
        initialize_params {
            size = 50
            image = "ubuntu-os-cloud/ubuntu-2004-lts"
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
        ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
    }

    provisioner "remote-exec" {
        inline = ["echo hello"]
        connection {
            type = "ssh"
            host = self.network_interface[0].access_config[0].nat_ip
            user = var.gce_ssh_user
            private_key = file("~/.ssh/gcp_terraform")
        }
    }

    provisioner "local-exec" {
        working_dir = "./ansible/"
        command = <<EOL
        ansible-playbook -i hosts/inventory.gcp.yaml ubuntu.yaml
        EOL
    }
}

resource "google_compute_instance" "arch_dev" {
    name = "arch-dev"
    machine_type = "e2-standard-4"
    zone = var.zone
    tags = ["dev-env"]

    boot_disk {
        initialize_params {
            size = 50
            image = "projects/arch-linux-gce/global/images/family/arch"
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
        ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
    }

    provisioner "remote-exec" {
        inline = ["echo hello"]
        connection {
            type = "ssh"
            host = self.network_interface[0].access_config[0].nat_ip
            user = var.gce_ssh_user
            private_key = file("~/.ssh/gcp_terraform")
        }
    }

    provisioner "local-exec" {
        working_dir = "./ansible/"
        command = <<EOL
        ansible-playbook -i hosts/inventory.gcp.yaml arch.yaml
        EOL
    }
}