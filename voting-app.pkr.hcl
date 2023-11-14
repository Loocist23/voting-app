packer {
  required_plugins {
    docker = {
      version = "> 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">= 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "image_name" {
  type    = string
  default = "ubuntu"
}

variable "username" {
  type    = string
  default = "myusername"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

source "docker" "ubuntu" {
  image  = "ubuntu:18.04"
  commit = true
}

build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu"
  ]

  provisioner "ansible" {
    playbook_file   = "./playbook.yml"
    extra_arguments = ["--scp-extra-args", "'-O'"]
  }

  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = ["packer-rocks"]
    only       = ["docker.ubuntu"]
  }
}
