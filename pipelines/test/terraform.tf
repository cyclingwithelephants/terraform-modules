terraform {
  required_version = "~> 0.12.0"

  backend "remote" {
    organization = "cyclingwithelephants"

    workspaces {
      # can think of as component name
      prefix = "hello-to-the-world"
    }
  }
}
