locals{ 
    env_vars= merge(read_terragrunt_config(find_in_parent_folders("variable.hcl")).locals, read_terragrunt_config("${get_repo_root()}/globalvariable.hcl").locals)
}
terraform {
    source = "git@github.com:Sulav-Adhikari/Terraform01.git//modules/workflow"
}

