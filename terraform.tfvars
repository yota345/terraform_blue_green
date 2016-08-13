auth_key_name        = "your_auth_key_name"
vpc_cidr             = "10.0.0.0/16"
ssh_key_path         = "~/.ssh/your_key.pem"
region               = "ap-northeast-1"
s3_bucket_name       = "blue-green-terraform-state"
state_key            = "terraform.tfstate"
rds_pass             = "your_password"
rds_size             = "db.t2.small"
elasticache_size     = "cache.m3.medium"
ssl_arn              = "your_ssl_arn"


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


// Blue
blue_ami              = "ami-374db956"
blue_instance_type    = "t2.small"
blue_instances_count  = "2"


// Green
green_ami             = "ami-374db956"
green_instance_type   = "t2.small"
green_instances_count = "2"
