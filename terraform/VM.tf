##########################################################
# VM.tf

data "yandex_compute_image" "nat_instance" {
  family = "nat-instance-ubuntu"
}

data "yandex_compute_image" "img_bastion" {
  family = "ubuntu-2004-lts"
}

data "yandex_compute_image" "vm_img" {
  family = "ubuntu-1804-lts"
}

data "template_file" "cloud_init" {
  template = "${file("cloud-init.tpl.yaml")}"
  vars =  {

        ssh_key = "${file(var.public_key_path)}"

    }
}

#####  NAT  ###########################################################
resource "yandex_compute_instance" "nat-instance" {
  zone        = "ru-central1-a"
  name        = "nat-instance"
  hostname    = "nat-instance"
  platform_id = "standard-v1"
  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat_instance.id
      type     = "network-hdd"
      size     = 10
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-nat-a.id
    ip_address = "10.0.0.5"
    nat = true
	nat_ip_address = "51.250.65.167"
    security_group_ids = [yandex_vpc_security_group.sg-inet-acc.id]
  }
  metadata = {
    user-data = "${data.template_file.cloud_init.rendered}"
    serial-port-enable = 1
  }
}

#####  BASTION  ###########################################################
resource "yandex_compute_instance" "bastion" {
  zone        = "ru-central1-a"
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v1"
  #service_account_id = "${module.sa_and_key.s3_writer}"
  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.img_bastion.id
      type     = "network-hdd"
      size     = 10
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-nat-a.id
    ip_address = "10.0.0.10"
    nat = true
	nat_ip_address = "51.250.75.189"
    security_group_ids = [yandex_vpc_security_group.sg-bastion.id]
  }
  metadata = {
    user-data = "${data.template_file.cloud_init.rendered}"
    serial-port-enable = 1
  }
}

#######  GITLAB  ###########################################################
resource "yandex_compute_instance" "gitlab" {
  zone        = "ru-central1-a"
  name        = "gitlab"
  hostname    = "gitlab"
  platform_id = "standard-v2"
  resources {
    cores  = 4
    memory = 8
    core_fraction = 50
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_img.id
      type     = "network-ssd"
      size     = 20
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-tools-a.id
    ip_address = "10.30.0.50"
    nat = false
    security_group_ids = [yandex_vpc_security_group.sg-ci-cd.id]
  }
  metadata = {
    user-data = "${data.template_file.cloud_init.rendered}"
    serial-port-enable = 1
  }
}

######  RUNNER  ###########################################################
resource "yandex_compute_instance" "runner" {
  zone        = "ru-central1-a"
  name        = "runner"
  hostname    = "runner"
  platform_id = "standard-v2"
  resources {
    cores  = 4
    memory = 4
    core_fraction = 50
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_img.id
      type     = "network-ssd"
      size     = 20
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-tools-a.id
    ip_address = "10.30.0.51"
    nat = false
    security_group_ids = [yandex_vpc_security_group.sg-ci-cd.id]
  }
  metadata = {
    user-data = "${data.template_file.cloud_init.rendered}"
    serial-port-enable = 1
  }
}

######  MONITORING  ###########################################################

resource "yandex_compute_instance" "monitoring" {
  zone        = "ru-central1-a"
  name        = "monitoring"
  hostname    = "monitoring"
  platform_id = "standard-v1"
#  folder_id = var.stage_folder_id
  allow_stopping_for_update = true
  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_img.id
      type     = "network-hdd"
      size     = 10
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-tools-a.id
    ip_address = "10.30.0.200"
    nat = false
    security_group_ids = [yandex_vpc_security_group.sg-ci-cd.id]
  }
  metadata = {
    user-data = "${data.template_file.cloud_init.rendered}"
    serial-port-enable = 1
  }
}

######  APP (wordpress)  ###########################################################

resource "yandex_compute_instance" "app" {
  zone        = "ru-central1-a"
  name        = "app"
  hostname    = "app"
  platform_id = "standard-v1"
  folder_id = var.stage_folder_id
  allow_stopping_for_update = true
  resources {
    cores  = 4
    memory = 4
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_img.id
      type     = "network-hdd"
      size     = 10
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-stage-a.id
    ip_address = "10.20.0.100"
    nat = false
    security_group_ids = [yandex_vpc_security_group.sg-stage.id]
  }
  metadata = {
    user-data = "${data.template_file.cloud_init.rendered}"
    serial-port-enable = 1
  }
}
#
########  DB01  ###########################################################

resource "yandex_compute_instance" "db01" {
  zone        = "ru-central1-a"
  name        = "db01"
  hostname    = "db01"
  platform_id = "standard-v1"
  folder_id = var.stage_folder_id
  allow_stopping_for_update = true
  resources {
    cores  = 4
    memory = 4
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_img.id
      type     = "network-hdd"
      size     = 10
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-stage-a.id
    ip_address = "10.20.0.150"
    nat = false
    security_group_ids = [yandex_vpc_security_group.sg-stage.id]
  }
  metadata = {
    user-data = "${data.template_file.cloud_init.rendered}"
    serial-port-enable = 1
  }
}
#
##########  DB02  ##########################################################

resource "yandex_compute_instance" "db02" {
  zone        = "ru-central1-b"
  name        = "db02"
  hostname    = "db02"
  platform_id = "standard-v1"
  folder_id = var.stage_folder_id
  allow_stopping_for_update = true
  resources {
    cores  = 4
    memory = 4
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_img.id
      type     = "network-hdd"
      size     = 10
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-stage-b.id
    ip_address = "10.120.0.150"
    nat = false
    security_group_ids = [yandex_vpc_security_group.sg-stage.id]
  }
  metadata = {
    user-data = "${data.template_file.cloud_init.rendered}"
    serial-port-enable = 1
  }
}
# _EOF
