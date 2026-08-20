# Region
#already configured in terraform.tf file
# provider "aws" {

# 	region="us-west-2"

# }

# Key Value pair

resource aws_key_pair my_key_pair {
    key_name="tera-key"
    public_key=file("tera-key.pub")
} 

# VPC Default

resource aws_default_vpc default {
}

# Security Group 

resource aws_security_group my_security_group {

name="terra-security-group"
#interpolation is a way which allows you to reference the value of one resource in another resource. In this case, we are referencing the ID of the default VPC that we created earlier and using it to set the vpc_id attribute of the security group.
vpc_id= aws_default_vpc.default.id  # interpolation
description = "this is Inbound and outbound rules for your instance Security group"

}

# Inbound & Outbount port rules


# inbound rule is called ingress rule. It allows incoming traffic on port 80 (HTTP) from anywhere. The ip_protocol is set to tcp, which means only TCP traffic is allowed. The cidr_ipv4 is set to 0.0.0.0/0, which means all IP addresses are allowed.
resource aws_vpc_security_group_ingress_rule allow_http {
    security_group_id = aws_security_group.my_security_group.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 80
    ip_protocol       = "tcp"
    to_port           = 80
}
# inbound rule is called ingress rule. It allows incoming traffic on port 22 (SSH) from anywhere. The ip_protocol is set to tcp, which means only TCP traffic is allowed. The cidr_ipv4 is set to 0.0.0.0/0, which means all IP addresses are allowed.
resource aws_vpc_security_group_ingress_rule allow_ssh {
    security_group_id = aws_security_group.my_security_group.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 22
    ip_protocol       = "tcp"
    to_port           = 22
}

# outbound rule is called egress rule. It allows all traffic to go out of the instance. The ip_protocol is set to -1, which means all protocols are allowed. The cidr_ipv4 is set to 0.0.0.0/0, which means all IP addresses are allowed.
resource aws_vpc_security_group_egress_rule allow_all_traffic {
    security_group_id = aws_security_group.my_security_group.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1" # semantically equivalent to all ports
}


# EC2 instance


resource aws_instance my_instance {

	# count = 3 # number of instances
    # for_each is a meta-argument in Terraform that allows you to create multiple instances of a resource based on a map or set of strings. In this case, we are using a map to create two EC2 instances with different names and instance types. The keys of the map are the names of the instances, and the values are the instance types. The tomap function is used to convert the map into a format that Terraform can use.
    for_each = tomap({
        TWS-Junoon-automate-micro  = "t2.micro",
        TWS-Junoon-automate-medium = "t2.medium",
        TWS-Junoon-automate-small  = "t2.small",
    }) # meta argument
	ami = "ami-0d76b909de1a0595d" # OS AMI ID
    user_data = file("nginx_script.sh")
	# instance_type = var.instance_type # Instance Type by assigning variable from variables.tf file
    instance_type = each.value # Instance Type by assigning value from for_each map

	key_name = aws_key_pair.my_key_pair.key_name	# Key pair
	vpc_security_group_ids = [aws_security_group.my_security_group.id] # VPC & Security Group
    depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key_pair]
	
	# root storage (EBS)
	root_block_device {
		volume_size = var.env =="prd" ? 20 : var.ec2_default_root_storage_size # Conditional expression to set volume size based on environment
		volume_type = "gp3"
	}

	tags = {
    Name = each.key
    }
}
# we can import from aws with the help of commmand  -> terraform import aws_instance.my_new_instance i-0e1f2d3c4b5a6d7e8#id of the awsec2 instance which is to be imported from aws
# resource "aws_instance" "my_new_instance" {
#     ami           = "unknown"
#     instance_type = "unknown"
# }