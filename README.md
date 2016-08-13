# terraform_blue_green

## Description
This terraform template enables you to construct aws resources.
With autoscaling the template conduct blue green deployment.


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
```

Apply your changes.
```
# Blue
terraform apply -target= -target=module.blue
# Green
terraform apply -target= -target=module.green
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

You could push/pull your tfstate file in S3.
```
## push
terraform remote push

## pull
terraform remote pull
```
