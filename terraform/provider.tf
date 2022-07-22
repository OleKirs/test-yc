provider "yandex" {
  service_account_key_file = file("key.json")
#  token = var.yc_token
  cloud_id = var.cloud_id
  folder_id = var.folder_id
}

