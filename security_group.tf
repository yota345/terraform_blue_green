resource "aws_security_group" "terraform_elb_security_group" {
  name        = "terraform_elb_security_group"
  vpc_id      = "${aws_vpc.terraform_vpc.id}"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "TERRAFORM_ELB_SG"
  }
}


resource "aws_security_group" "terraform_ec2_security_group" {
  name        = "terraform_ec2_security_group"
  vpc_id      = "${aws_vpc.terraform_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.terraform_elb_security_group.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "TERRAFORM_EC2_SG"
  }
}


resource "aws_security_group" "terraform_rds_security_group" {
  name        = "terraform_rds_security_group"
  vpc_id      = "${aws_vpc.terraform_vpc.id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.terraform_ec2_security_group.id}"]
  }
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.terraform_ec2_security_group.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "TERRAFORM_RDS_SG"
  }
}


resource "aws_security_group" "terraform_elasticache_security_group" {
  name        = "terraform_elasticache_security_group"
  vpc_id      = "${aws_vpc.terraform_vpc.id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.terraform_ec2_security_group.id}"]
  }
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = ["${aws_security_group.terraform_ec2_security_group.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "TERRAFORM_ELASTICACHE_SG"
  }
}
