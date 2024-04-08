locals{ 
    env_vars= merge(read_terragrunt_config(find_in_parent_folders("variable.hcl")).locals, read_terragrunt_config("${get_repo_root()}/globalvariable.hcl").locals)
}

include "root"{
    path = find_in_parent_folders()
}

include "env"{
    path = "${get_repo_root()}/_env/myvpc.hcl"
}

inputs = {
    vpc_subnet_module = {
    name                 = "subnet-network-ecs"
    cidr_block           = "10.0.0.0/16"
    azs                  = ["us-east-1a", "us-east-1b"]
    public_subnets       = ["10.0.106.0/24", "10.0.107.0/24"]
    enable_nat_gateway   = false 
    }
}

    # public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
