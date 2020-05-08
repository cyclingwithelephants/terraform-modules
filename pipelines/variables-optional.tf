variable "substitutions" {
  description = "the values for variables to use inside the cloudbuild pipeline"
  type        = map(string)
  default = {
    # _ENV      = "default"
    # _LOCATION = ""
    _WORKSPACE_NAME = ""
  }
}

variable "github" {
  description = ""
  type        = map(string)
  default = {
    branch     = ""
    commit_tag = ""
  }
}

variable "timeouts" {
  description = ""
  type        = map(string)
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
