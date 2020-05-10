terraform {
  required_version = "~> 0.12.0"

  backend "remote" {
    organization = "Cyclingwithelephants"

    workspaces {
      # can think of as component name
      prefix = "pipelines-meta"
    }
  }
}
