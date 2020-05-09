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
    repo_owner = "Cyclingwithelephants"
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
