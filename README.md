# terraform repository

## Description

Terraform repository with simple modules
## Usage
Add AWS Secrets with your values
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

Use S3 backend to store terraform.tfstate file
```
    backend "s3" {
    bucket         = "rd-state-bucket"
    dynamodb_table = "state-lock"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "us-east-2"
    }
```
To check if SSH Key exists use 
```
data "external" "check_key" {
  program = ["bash", "${path.module}/check_key.sh"]

  query = {
    key_name = var.key_name
    region   = var.region
  }
}
```
Script to check 
```
#!/bin/bash

# Отримання key_name з вхідних даних
INPUT=$(cat)
KEY_NAME=$(echo $INPUT | jq -r .key_name)
REGION=$(echo "$INPUT" | jq -r .region)

# Перевірка існування ключа
if aws ec2 describe-key-pairs --region "$REGION" --key-names "$KEY_NAME" &>/dev/null; then
  echo "{\"exists\":\"true\"}"
else
  echo "{\"exists\":\"false\"}"
fi
```

To add additional EC2 instance

```
module "<Add Module name>" {
  source                      = "./modules/ec2-instance"
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.my_vpc.public_subnet_ids[0]
  security_groups_name        = module.sg-external.sg_id
  key_name                    = try(aws_key_pair.key[0].key_name, var.key_name)
  associate_public_ip_address = true
  instance_name               = "<Add instance name>"
  instance_role               = "<Add instance Role>"
  instance_env                = "<Add instance env>"

  depends_on = [aws_key_pair.key]
}
```

## Ref
#TODO: Add link for terraform-s3 repo