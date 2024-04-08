remote_state{
  backend = "s3"
  generate ={
    path = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket = "sulav-terraform-state-dev"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "sulav-terraform-locktable-dev"
  }
}

generate "provider"{
  path = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
  terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.43.0"
    }
  }
}


provider "aws" {
    region = "us-east-1"
    shared_credentials_files = ["/home/sulav/.aws/credentials"]
    shared_config_files = ["/home/sulav/.aws/config"]

  default_tags {
    tags = {
      Creator   = "sulav.adk.7@gmail.com"
      Project   = "Intern"
      Deletable = "Yes"
    }
  }

}
EOF
}
