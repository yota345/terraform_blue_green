key_pair_name        = "hubbit_orchestration_key"
vpc_cidr             = "10.0.0.0/16"
region               = "ap-northeast-1"
s3_bucket_name       = "blue-green-terraform-state"
state_key            = "terraform.tfstate"
rds_pass             = "password"
rds_size             = "db.t2.small"
elasticache_size     = "cache.m3.medium"
ssl_arn              = "arn:aws:acm:ap-northeast-1:046984394810:certificate/0796423d-675e-4014-854e-84207d9fe430"


web_subnets = {
  "0" = "10.0.193.0/26"
  "1" = "10.0.193.64/26"
}

rds_subnets = {
  "0" = "10.0.194.0/26"
  "1" = "10.0.194.64/26"
}

availability_zones = {
  "0" = "ap-northeast-1a"
  "1" = "ap-northeast-1c"
}


// Blue autoscaling group
blue_ami              = "ami-374db956"
blue_instance_type    = "t2.small"
blue_instances_count  = "2"


// Green autoscaling group
green_ami             = "ami-374db956"
green_instance_type   = "t2.small"
green_instances_count = "2"
