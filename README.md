# terraform_blue_green

## Description
This terraform template enables you to construct basic blue green architecture on AWS.


## Requirement

- terraform 0.7.x


## Usuage

Set your aws credentials.
```
vi ~/.zshrc

export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_DEFAULT_REGION="ap-northeast-1"
```

Set your environment to terraform.tfvars. 
You need to override some, for instance, key_pair_name to ssh ec2 instance, ssh_key_path, rds_pass, ssl_arn, and so on.

Load modules.
```
terraform get
```

You could find out your changes.
```
# Blue
terraform plan -target= -target=module.blue

# Green
terraform plan -target= -target=module.green

# Blue and Green
terraform plan -target= -target=module.blue -target=module.green
```

Apply your changes.
```
# Blue
terraform apply -target= -target=module.blue

# Green
terraform apply -target= -target=module.green

# Blue and Green
terraform apply -target= -target=module.blue -target=module.green
```

Destroy your all aws resources.
```
terraform destroy
```

Upload your tfstate file to S3 to prevent from conflicting.
```
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=blue-green-terraform-state" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="region=ap-northeast-1"
```

You could push/pull your tfstate file from/to S3.
```
## push
terraform remote push

## pull
terraform remote pull
```
