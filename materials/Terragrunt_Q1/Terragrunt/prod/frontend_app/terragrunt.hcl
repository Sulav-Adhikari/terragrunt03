locals{ 
    env_vars= merge(read_terragrunt_config(find_in_parent_folders("variable.hcl")).locals, read_terragrunt_config("${get_repo_root()}/globalvariable.hcl").locals)
}

include "root"{
    path = find_in_parent_folders()
}

include "env"{
    path = "${get_repo_root()}/_env/frontendApp.hcl"
}



inputs = {
  domain_name = "sulav-adhikari.com.np"
}
