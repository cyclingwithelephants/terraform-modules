variable "tool_name" {
  description = "the language of the thing you want to add CI/CD to, e.g. terraform, go"
  type        = string
  default     = "terraform"
}

variable "code_directory_override" {
  description = "if your code doesn't exist under the path $repo_root/$tool_name/ then specify where to immediately cd to for the build."
  type        = string
  default     = ""
}
