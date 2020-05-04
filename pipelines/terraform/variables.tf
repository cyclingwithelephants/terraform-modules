variable "github" {
  description = ""
  type        = map(string)
  default = {
    repo_name  = ""
    repo_owner = ""
    branch     = ""
    commit_tag = ""
  }
}

variable "included_files" {
  description = ""
}

variable "substitutions" {
  description = "the values for variables to use inside the cloudbuild pipeline"
  type        = map(string)
  default = {
    # _ENV      = "default"
    # _LOCATION = ""
  }
}

variable "trigger_name" {
  description = "The name of the trigger, base this on what object is being deployed and whether is is a push or a pr."
  type        = string
}

variable "trigger_description" {
  description = ""
  type        = string
}

variable "timeouts" {
  descriptionm = ""
  type         = map(string)
  default = {
    create = "40m"
    update = "40m"
    delete = "40m"
  }
}

variable "create_triggers" {
  description = "whether or not to create a trigger for each change type"
  type        = map(bool)
  default = {
    push = true
    pr   = true
  }
}

variable "push_pipeline_commands" {
  desription = "The string of commands for the push triggered pipeline to run in a terraform container"
  type       = string
  default    = <<-EOF
    |
    cd terraform

    terraform validate

    terraform init

    terraform plan \
      -var-file=config/terraform.tfvars \
      -var-file = config/secrets.tfvars

    [[ "$BRANCH" == "master" ]] && terraform apply \
      --auto-approve \
      ./tfplan
    EOF
}

variable "pr_pipeline_commands" {
  desription = "The string of commands for the pull request triggered pipeline to run in a terraform container"
  type       = string
  default    = <<-EOF
    |
    cd terraform

    terraform validate

    terraform init

    terraform plan \
      -out=./tfplan \
      -var-file=config/terraform.tfvars \
      -var-file = config/secrets.tfvars
    EOF

}
