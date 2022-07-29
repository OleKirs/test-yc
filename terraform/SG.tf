###################################################################
##
##       SG.tf
##
###### NAT-INET ###################################################
resource "yandex_vpc_security_group" "sg-inet-acc" {
  name        = "sg-inet-acc"
  description = "defines which environments can access NAT-Instance for Internet access"
  network_id  = yandex_vpc_network.vpc-net-01.id

  ingress {
    protocol       = "ICMP"
    description    = "Allow pings from all networks for tshoot"
    v4_cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    protocol       = "TCP"
    description    = "allows remote access only through Bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ANY can only access well-known ports to HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ANY can only access well-known ports to HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    description    = "From 10.30.0.200/32 To Node exporter"
    v4_cidr_blocks = ["10.30.0.200/32"]
    port           = 9100
  }

  egress {
    protocol       = "ANY"
    description    = "NAT-INSTANCE can access to internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

######## BASTION #################################################

resource "yandex_vpc_security_group" "sg-bastion" {
  name        = "sg-bastion"
  description = "allows connecting to bastion only from whitelisted address"
  network_id  = yandex_vpc_network.vpc-net-01.id

  labels = {
     type = "bastion-whitelist"
   }

  ingress {
    protocol       = "TCP"
    description    = "allow-ssh-from-trusted-ip"
    v4_cidr_blocks = var.bastion_whitelist_ip
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "allow-icmp-from-trusted-ip"
    v4_cidr_blocks = var.bastion_whitelist_ip
  }

  egress {
    protocol       = "ANY"
    description    = "we allow any egress, since we block on ingress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

######### CI_CD ################################################

resource "yandex_vpc_security_group" "sg-ci-cd" {
  name        = "sg-ci-cd"
  description = "allows ci-cd tools to manage stage and prod"
  network_id  = yandex_vpc_network.vpc-net-01.id


  ingress {
    protocol       = "TCP"
    description    = "allows remote access only through Bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "allows ping only from bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
  }

  ingress {
    protocol       = "ICMP"
    description    = "allows ping from self_SG"
    predefined_target = "self_security_group"
  }

  ingress {
    protocol          = "TCP"
    description       = "allows for config sync for ci-cd workers"
    predefined_target = "self_security_group"
    port = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ANY can only access well-known ports to HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ANY can only access well-known ports to HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    description    = "ANY can only access to Grafana"
    v4_cidr_blocks = ["127.0.0.1/32","10.0.0.0/8"]
    port           = 3000
  }

  ingress {
    protocol       = "TCP"
    description    = "ANY can only access to Prometeus"
    v4_cidr_blocks = ["127.0.0.1/32","10.0.0.0/8"]
    port           = 9090
  }

  ingress {
    protocol       = "TCP"
    description    = "ANY can only access to Alertmanager"
    v4_cidr_blocks = ["127.0.0.1/32","10.0.0.0/8"]
    port           = 9093
  }

  ingress {
    protocol       = "TCP"
    description    = "10.30.0.200/32 can only access to Node_exporter"
    predefined_target = "self_security_group"
    port           = 9100
  }

  egress {
    protocol       = "ANY"
    description    = "Allow any egress, since we block prod on ingress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

########### STAGE ##############################################

resource "yandex_vpc_security_group" "sg-stage" {
  name        = "sg-stage"
  description = "allows ci-cd tools to manage stage and prod"
  network_id  = yandex_vpc_network.vpc-net-01.id
  folder_id   = var.stage_folder_id

  ingress {
    protocol       = "ICMP"
    description    = "allows ping  through Bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
  }

  ingress {
    protocol       = "TCP"
    description    = "allows remote access through Bastion"
    security_group_id  = yandex_vpc_security_group.sg-bastion.id
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "allows deploy from ci-cd"
    security_group_id  = yandex_vpc_security_group.sg-ci-cd.id
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ANY can only access well-known ports to HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ANY can only access well-known ports to HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    description    = "allows rsync from ci-cd"
    security_group_id  = yandex_vpc_security_group.sg-ci-cd.id
    port           = 873
  }

  ingress {
    protocol       = "TCP"
    description    = "From 10.30.0.200/32 To Node exporter"
    security_group_id  = yandex_vpc_security_group.sg-ci-cd.id
    port           = 9100
  }

  egress {
    protocol       = "ANY"
    description    = "we allow any egress for stage, since we block prod on ingress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# _EOF_
