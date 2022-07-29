##################################################################
#
#                      vpc.tf
#
################ NET-01 ##########################################
# Network
resource "yandex_vpc_network" "vpc-net-01" {
  name = "vpc-net-01"
}
################ RT-INET #########################################
# Routing table
resource "yandex_vpc_route_table" "rt-inet" {
  name = "rt-inet"
  network_id = yandex_vpc_network.vpc-net-01.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "10.0.0.5"
  }
}
############### Subnet-NAT-A ######################################
resource "yandex_vpc_subnet" "subnet-nat-a" {
  name           = "subnet-nat-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-net-01.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}
############### Subnet-STAGE-A ####################################
resource "yandex_vpc_subnet" "subnet-stage-a" {
  name           = "subnet-stage"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-net-01.id
  v4_cidr_blocks = ["10.20.0.0/24"]
  route_table_id = yandex_vpc_route_table.rt-inet.id
  folder_id      = var.stage_folder_id
}
############### Subnet-STAGE-B ####################################
resource "yandex_vpc_subnet" "subnet-stage-b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc-net-01.id
  v4_cidr_blocks = ["10.120.0.0/24"]
  route_table_id = yandex_vpc_route_table.rt-inet.id
  folder_id      = var.stage_folder_id
}
############### Subnet-TOOLS-A ####################################
resource "yandex_vpc_subnet" "subnet-tools-a" {
  name           = "subnet-tools"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-net-01.id
  v4_cidr_blocks = ["10.30.0.0/24"]
  route_table_id = yandex_vpc_route_table.rt-inet.id
  folder_id      = var.stage_folder_id
}
# _EOF_
