variable "key_pair_name" {}
variable "green_ami" {}
variable "green_instance_type" {}
variable "ssl_arn" {}
variable "green_instances_count" {}
variable "blue_ami" {}
variable "blue_instance_type" {}
variable "blue_instances_count" {}



resource "aws_elb" "terraform_elb" {
  name                        = "terraform-elb"
  subnets                     = ["${aws_subnet.terraform_subnet.*.id}"]
  security_groups             = ["${aws_security_group.terraform_elb_security_group.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 180
  connection_draining         = true
  connection_draining_timeout = 600

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port       = 80
    instance_protocol   = "http"
    lb_port             = 443
    lb_protocol         = "https"
    ssl_certificate_id  = "${var.ssl_arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:80"
    interval            = 20
  }
}


module "blue" {
  source                        = "./blue"
  terraform_subnet_a            = "${aws_subnet.terraform_subnet.0.id}"
  terraform_subnet_b            = "${aws_subnet.terraform_subnet.1.id}"
  terraform_elb                 = "${aws_elb.terraform_elb.name}"
  terraform_ec2_security_group  = "${aws_security_group.terraform_ec2_security_group.id}"
  blue_ami                      = "${var.blue_ami}"
  blue_instance_type            = "${var.blue_instance_type}"
  key_pair_name                 = "${var.key_pair_name}"
  blue_instances_count          = "${var.blue_instances_count}"

}


module "green" {
  source                        = "./green"
  terraform_subnet_a            = "${aws_subnet.terraform_subnet.0.id}"
  terraform_subnet_b            = "${aws_subnet.terraform_subnet.1.id}"
  terraform_elb                 = "${aws_elb.terraform_elb.name}"
  terraform_ec2_security_group  = "${aws_security_group.terraform_ec2_security_group.id}"
  green_ami                     = "${var.green_ami}"
  green_instance_type           = "${var.green_instance_type}"
  key_pair_name                 = "${var.key_pair_name}"
  green_instances_count         = "${var.green_instances_count}"
}
