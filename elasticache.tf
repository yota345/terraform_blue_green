variable "elasticache_size" {}


resource "aws_elasticache_cluster" "terraform_elasticache" {
  cluster_id               = "elasticache-cluster"
  engine                   = "redis"
  engine_version           = "2.8.24"
  node_type                = "${var.elasticache_size}"
  port                     = 6379
  num_cache_nodes          = 1
  parameter_group_name     = "default.redis2.8"
  subnet_group_name        = "${aws_elasticache_subnet_group.terraform_elasticache_subnet_group.id}"
  security_group_ids       = ["${aws_security_group.terraform_elasticache_security_group.id}"]
  availability_zone        = "ap-northeast-1c"
  apply_immediately        = "false"
  snapshot_retention_limit = "14"
  tags {
    Name = "terraform_elasticache"
  }
}
