variable "included_files" {
  description = "The list of files/directories (can include * and **) to trigger this/these triggers when they change."

}

variable "trigger_name" {
  description = "The name of the trigger, base this on what object/layer is being deployed. e.g. microservices, networking_layer, project_layer"
  type        = string
}

variable "trigger_description" {
  description = "A short (or long) description to talk about any changes to the pipeline that make this different from the regular default trigger that is defined."
  type        = string
}

variable "tool_name" {
  description = ""
  type        = string
  default     = "terraform"
}

variable "starting_directory_overrides" {
  description = "if your code doesn't exist under the path $repo_root/$tool_name/ then specify where to immediately cd to for the build."
  type        = map(string)
  default = {
    pr       = ""
    push     = ""
    tag_push = ""
  }
}
