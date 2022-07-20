##########################################################
# vpc.tf

##########################################################
# Network
resource "yandex_vpc_network" "vpc-infra" {
  name = "vpc-infra"
}

##########################################################
# Routing table
resource "yandex_vpc_route_table" "rt-inet" {
  name = "rt-inet"
  network_id = yandex_vpc_network.vpc-infra.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "10.0.0.5"
  }
}

##########################################################
resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-infra.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

##########################################################
resource "yandex_vpc_subnet" "subnet-b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc-infra.id
  v4_cidr_blocks = ["172.31.200.0/24"]
}

##########################################################
resource "yandex_vpc_subnet" "subnet-stage" {
  name           = "subnet-stage"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-infra.id
  v4_cidr_blocks = ["10.20.0.0/24"]
  route_table_id = yandex_vpc_route_table.rt-inet.id
  folder_id      = var.stage_folder_id
}

##########################################################
resource "yandex_vpc_subnet" "subnet-tools" {
  name           = "subnet-tools"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-infra.id
  v4_cidr_blocks = ["10.30.0.0/24"]
  route_table_id = yandex_vpc_route_table.rt-inet.id
  folder_id      = var.stage_folder_id
}
