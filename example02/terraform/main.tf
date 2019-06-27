provider "alicloud"{
}

resource "alicloud_vpc" "main"{
	cidr_block="${var.vpc_cidr}"
}

resource "alicloud_vswitch" "main"{
	vpc_id="${alicloud_vpc.main.id}"
	cidr_block="${var.vswitch_cidr}"
	availability_zone="${var.zone}"
	depends_on=["alicloud_vpc.main"]
}

resource "alicloud_security_group" "group"{
	name="${var.sg_name}"
	description="New Security group for educational purpose only"
	vpc_id="${alicloud_vpc.main.id}"
}

resource "alicloud_security_group_rule" "http-in"{
	type="${var.sg_type}"
	ip_protocol="${var.ip_protocol}"
	nic_type="${var.nic_type}"
	policy="${var.policy}"
	port_range="80/80"
	priority="${var.priority}"
	security_group_id="${alicloud_security_group.group.id}"
	cidr_ip="${var.cidr}"
}

resource "alicloud_security_group_rule" "https-in"{
	type="${var.sg_type}"
	ip_protocol="${var.ip_protocol}"
	nic_type="${var.nic_type}"
	policy="${var.policy}"
	port_range="443/443"
	priority="${var.priority}"
	security_group_id="${alicloud_security_group.group.id}"
	cidr_ip="${var.cidr}"
}

resource "alicloud_security_group_rule" "ssh-in"{
	type="${var.sg_type}"
	ip_protocol="${var.ip_protocol}"
	nic_type="${var.nic_type}"
	policy="${var.policy}"
	port_range="22/22"
	priority="${var.priority}"
	security_group_id="${alicloud_security_group.group.id}"
	cidr_ip="${var.cidr}"
}

resource "alicloud_instance" "node01"{
	instance_name="${var.instancenode1}"
	host_name="${var.instancenode1}"
	image_id="${var.image_id1}"
	instance_type="${var.instance_type}"
	count="${var.count}"
	security_groups=["${alicloud_security_group.group.id}"]
	internet_max_bandwidth_out="${var.internet_bandwidth}"
	internet_charge_type="${var.internet_charge}"
	vswitch_id="${alicloud_vswitch.main.id}"
}

resource "alicloud_instance" "node02"{
	instance_name="${var.instancenode2}"
	host_name="${var.instancenode2}"
	image_id="${var.image_id2}"
	instance_type="${var.instance_type}"
	count="${var.count}"
	security_groups=["${alicloud_security_group.group.id}"]
	internet_max_bandwidth_out="${var.internet_bandwidth}"
	internet_charge_type="${var.internet_charge}"
	vswitch_id="${alicloud_vswitch.main.id}"
}

resource "alicloud_key_pair_attachment" "attach"{
	key_name="${var.key_name}"	
	instance_ids=["${alicloud_instance.node01.*.id}","${alicloud_instance.node02.*.id}"]
}

resource "alicloud_slb" "instance"{
	name="${var.slb_name}"
	internet_charge_type="${var.internet_charge}"
	internet="${var.inet}"
}

resource "alicloud_slb_listener" "listener"{
	load_balancer_id="${alicloud_slb.instance.id}"
	backend_port="${var.port_listener}"
	frontend_port="${var.port_listener}"
	protocol="${var.protocol}"
	bandwidth="${var.bandwidth}"
}

resource "alicloud_slb_attachment" "default"{
	load_balancer_id="${alicloud_slb.instance.id}"
	instance_ids=["${alicloud_instance.node01.*.id}","${alicloud_instance.node02.*.id}"]
}

resource "ansible_host" "node01"{
	inventory_hostname="${var.instancenode1}"
	vars{
		ansible_ssh_host="${alicloud_instance.node01.public_ip}"
		ansible_ssh_user="${var.ssh_user}"
		ansible_ssh_private_key_file="${var.key_name}.pem"
	}
}

resource "ansible_host" "node02"{
	inventory_hostname="${var.instancenode2}"
	vars{
		ansible_ssh_host="${alicloud_instance.node02.public_ip}"
		ansible_ssh_user="${var.ssh_user}"
		ansible_ssh_private_key_file="${var.key_name}.pem"
		ansible_python_interpreter="/usr/bin/python3"
	}
}
