provider "alicloud"{
}

resource "alicloud_instance" "eg-1"{
	instance_type="ecs.g5.large"
	image_id="centos_7_06_64_20G_alibase_20190218.vhd"
	security_groups=["sg-k1agjazrdjzag37rx3ab"]
	vswitch_id="vsw-k1a38rwbjbm1hk7z53cem"
	internet_max_bandwidth_out=2
}

resource "alicloud_key_pair_attachment" "attachment"{
	key_name="ivan-intern"
	instance_ids=["${alicloud_instance.eg-1.*.id}"]
}

resource "ansible_host" "example"{
	inventory_hostname="localhost"
	#groups=["web"]
	vars{
		ansible_ssh_host="${alicloud_instance.eg-1.public_ip}"
		ansible_ssh_user="root"
		ansible_ssh_private_key_file="ivan-intern.pem"
#		ansible_python_interpreter="/usr/bin/python3"
	}
}

#resource "ansible_host" "example1"{
#	inventory_hostname="google.com"
#	groups=["web"]
#	vars{
#		ansible_user="admin"
#	}
#}

#resource "ansible_group" "web"{
#	inventory_group_name="web"
#	children=["foo","bar","baz"]
#	vars{
#		foo="bar"
#		bar=2
#	}
#}
