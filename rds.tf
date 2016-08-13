variable "rds_pass" {}
variable "rds_size" {}


resource "aws_db_instance" "terraform_db_instance" {
  identifier                  = "terraform-db-instance"
  allocated_storage           = 10
  engine                      = "postgres"
  engine_version              = "9.4.7"
  instance_class              = "${var.rds_size}"
  name                        = "terraform_production"
  username                    = "master"
  password                    = "${var.rds_pass}"
  db_subnet_group_name        = "${aws_db_subnet_group.terraform_db_subnet_group.id}"
  parameter_group_name        = "default.postgres9.4"
  vpc_security_group_ids      = ["${aws_security_group.terraform_rds_security_group.id}"]
  port                        = 5432
  multi_az                    = "true"
  backup_retention_period     = "14"
  backup_window               = "22:29-22:59"
  apply_immediately           = "false"
  auto_minor_version_upgrade  = "false"
  allow_major_version_upgrade = "false"
}
