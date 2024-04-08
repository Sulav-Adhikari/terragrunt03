locals{ 
    env_vars= merge(read_terragrunt_config(find_in_parent_folders("variable.hcl")).locals, read_terragrunt_config("${get_repo_root()}/globalvariable.hcl").locals)
}
terraform {
    source = "../../terragrunt/vpc_module"
}