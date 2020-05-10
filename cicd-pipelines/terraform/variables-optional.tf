variable "substitutions" {
  description = "the values for variables to use inside the cloudbuild pipeline"
  type        = map(string)
  default     = {}
}

variable "github" {
  description = ""
  type        = map(string)
  default = {
    branch     = ""
    commit_tag = ""
    repo_name  = ""
    repo_owner = "cyclingwithelephants"
  }
}

variable "create_triggers" {
  description = "whether or not to create a trigger for each code change type"
  type        = map(bool)
  default = {
    push = true
    pr   = true
  }
}

variable "ignored_files" {
  description = <<-EOF
    If ignored_files and changed files (as in for the set of changed files in
    the git commit) are both empty, then they are not used to
    determine whether or not to trigger a build. If ignoredFiles is not empty,
    then we ignore any files that match any of the ignored_file globs. If the
    change has no files that are outside of the ignoredFiles globs, then we do
    not trigger a build.

    ignoredFiles and includedFiles are file glob matches using
    https://golang.org/pkg/path/filepath/#Match extended with support for **.
    EOF
  type        = list(string)
  default     = [""]
}

variable "project_id" {
  description = "the GCP project_id to create resources inside"
  type        = string
  default     = "home-247920"
}

# variable "trigger_description" {
#   description = "A short (or long) description to talk about any changes to the pipeline that make this different from the regular default trigger that is defined."
#   type        = string
# }

variable "repo_name" {
  # This is taken from the environment, it's populated by cloudbuild in the pipeline
  description = "the name of the repository that this module was executed from"
  type        = string
}

variable "included_files" {
  description = "The list of files/directories (can include * and **) to trigger this/these triggers when they change."
  default     = []
}

# TODO: if left empty then all triggers possible will be made
variable "triggers" {
  type        = list
  description = "the list of triggers to make for this invocation e.g. ['push', 'pr',]."
  default = [
    "pr",
    "push",
  ]
}

variable "cloudbuild_overrides" {
  type        = map(string)
  description = "a map of the paths to the cloudbuild files for each type of trigger, respectively"
  default = {
    push = ""
    pr   = ""
  }
}
