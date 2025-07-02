terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "terraform-network"
}

resource "docker_image" "mysql" {
  name = "mysql:5.7"
  keep_locally = false
}

resource "docker_container" "mysql" {
  name  = "terraform-mysql"
  image = docker_image.mysql.name
  networks_advanced {
    name = docker_network.app_network.name
  }

  env = [
    "MYSQL_ROOT_PASSWORD=rootpass",
    "MYSQL_DATABASE=testdb",
    "MYSQL_USER=urx",
    "MYSQL_PASSWORD=urxpass"
  ]

  ports {
    internal = 3306
    external = 3306
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "web" {
  name  = "terraform-web"
  image = docker_image.nginx.name
  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 80
    external = 8080
  }

  depends_on = [docker_container.mysql]
}
