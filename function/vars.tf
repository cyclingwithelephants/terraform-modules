variable "memory_mb" {
  type = "string"
  default = "128"
}

variable "description" {
  type = "string"
  default = "This is a description of the function to be invoked"
}

variable "function_name" {
  type = "string"
  default = ""
}

variable "zipfile_name" {
  type = "string"
  default = ""
}

variable "local_path_to_zipfile" {
  type = "string"
  default = "../function.go"
}

variable "timeout" {
  type = "string"
  default = "60"
}

variable "trigger_http" {
  type = "boolean"
  default = true
}

variable "entry_point" {
  type = "string"
  default = "helloGET"
}

variable "environment_variables" {
  type = "map"
  default = {}
}

variable "labels" {
  type = "map"
  default = {}
}

variable "project_id" {
  type = "string"
}

variable "region" {
 type = "string"
}

variable "source_repository_url" {
  type = "string"
}
