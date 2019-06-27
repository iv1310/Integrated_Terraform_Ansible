variable "instancenode1"{
	default="Node01-Centos"
	description="Instance name"
}

variable "instancenode2"{
	default="Node02-Ubuntu"
	description="Instance name"
}

variable "image_id1"{
	default="centos_7_06_64_20G_alibase_20190218.vhd"
}

variable "image_id2"{
	default="ubuntu_16_04_64_20G_alibase_20190513.vhd"
}

variable "instance_type"{
	default="ecs.g5.large"
}

variable "count"{
	default="1"
}

variable "internet_bandwidth"{
	default="2"
}

variable "internet_charge"{
	default="PayByTraffic"
}

variable "key_name"{
	default="ivan-intern"
}

variable "ssh_user"{
	default="root"
}

variable "cidr"{
	default="0.0.0.0/0"
}

variable "priority"{
	default=1
}

variable "policy"{
	default="accept"
}

variable "nic_type"{
	default="intranet"
}

variable "ip_protocol"{
	default="tcp"
}

variable "sg_type"{
	default="ingress"
}

variable "sg_name"{
	default="SLBBB"
}

variable "zone"{
	default="ap-southeast-5a"
}

variable "vpc_cidr"{
	default="192.168.0.0/21"
}

variable "vswitch_cidr"{
	default="192.168.1.0/24"
}

variable "slb_name"{
	default="Terraform-Ansible"
}

variable "inet"{
	default="true"
}

variable "port_listener"{
	default=80
}

variable "bandwidth"{
	default=5
}

variable "protocol"{
	default="http"
}

