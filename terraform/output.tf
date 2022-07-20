output "external_ip_address_nat" {
  value = yandex_compute_instance.nat-instance.network_interface.0.nat_ip_address
}

output "external_ip_address_bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

output "internal_ip_address_gitlab" {
  value = yandex_compute_instance.gitlab.network_interface.0.ip_address
}

output "internal_ip_address_runner" {
  value = yandex_compute_instance.runner.network_interface.0.ip_address
}

output "internal_ip_address_app_stage" {
  value = yandex_compute_instance.app.network_interface.0.ip_address
}

output "internal_ip_address_db01" {
  value = yandex_compute_instance.db01.network_interface.0.ip_address
}

output "internal_ip_address_db02" {
  value = yandex_compute_instance.db02.network_interface.0.ip_address
}

output "internal_ip_address_monitoring" {
  value = yandex_compute_instance.monitoring.network_interface.0.ip_address
}

