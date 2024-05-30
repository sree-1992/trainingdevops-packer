packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "mumbai" {
  source_ami    = var.ami
  instance_type = var.instance_type
  ssh_username  = "ec2-user"
  ami_name      = local.image_name

  tags = {
    Name    = local.image_name
    Project = var.project_name
    Env     = var.project_env
  }
}

build {
  sources = ["source.amazon-ebs.mumbai"]

  provisioner "shell" {
    script          = "./setup.sh"
    execute_command = "sudo {{.Path}} ${var.application_repository}"
  }
}
