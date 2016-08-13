variable "vpc_cidr" {}
variable "web_subnets" { default = {} }
variable "rds_subnets" { default = {} }
variable "availability_zones" { default = {} }


resource "aws_vpc" "terraform_vpc" {
    cidr_block           = "${var.vpc_cidr}"
    instance_tenancy     = "default"
    enable_dns_support   = "true"
    enable_dns_hostnames = "true"
    tags {
      Name = "terraform_vpc"
    }
}


resource "aws_internet_gateway" "terraform_internet_gateway" {
    vpc_id = "${aws_vpc.terraform_vpc.id}"
    tags {
        Name = "terraform_internet_gateway"
    }
}


resource "aws_subnet" "terraform_subnet" {
    count             = 2
    vpc_id            = "${aws_vpc.terraform_vpc.id}"
    cidr_block        = "${lookup(var.web_subnets, count.index)}"
    availability_zone = "${lookup(var.availability_zones, count.index%2)}"
    tags {
        Name =  "${format("terraform_subnet_%02d", count.index + 1)}"
    }
}


resource "aws_route_table" "terraform_route_table" {
    vpc_id = "${aws_vpc.terraform_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.terraform_internet_gateway.id}"
    }
    tags {
        Name = "terraform_route_table"
    }
}


resource "aws_route_table_association" "terraform_route_table_association" {
    count          = 2
    subnet_id      = "${element(aws_subnet.terraform_subnet.*.id, count.index)}"
    route_table_id = "${aws_route_table.terraform_route_table.id}"
}


resource "aws_subnet" "terraform_subnet_rds" {
    count             = 2
    vpc_id            = "${aws_vpc.terraform_vpc.id}"
    cidr_block        = "${lookup(var.rds_subnets, count.index)}"
    availability_zone = "${lookup(var.availability_zones, count.index%2)}"
    tags {
      Name = "${format("terraform_subnet_rds%02d", count.index + 1)}"
    }
}


resource "aws_db_subnet_group" "terraform_db_subnet_group" {
    name        = "terraform_db_subnet_group"
    description = "Group of subnets for Hubbit"
    subnet_ids  = ["${aws_subnet.terraform_subnet_rds.*.id}"]
    tags {
        Name = "terraform_db_subnet_group"
    }
}


resource "aws_elasticache_subnet_group" "terraform_elasticache_subnet_group" {
    name        = "terraform-elasticache-subnet-group"
    description = "terraform_elasticache_subnet_group"
    subnet_ids  = ["${aws_subnet.terraform_subnet_rds.*.id}"]
}
