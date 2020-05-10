locals {
  push = yamldecode(file("${path.module}/../instructions/terraform/push-cloudbuild.yaml"))
  args = [
    "-c",
    <<-EOF

    EOF
    ,
  ]
}

resource "google_cloudbuild_trigger" "push" {
  provider = google-beta
  count    = var.create_triggers["push"] == true ? 1 : 0

  build {
    dynamic "step" {
      for_each = [for step in local.push.steps : {
        # mandatory
        name = step.name

        # optional
        timeout  = lookup(step, "timeout", "")
        wait_for = lookup(step, "wait_for", "")
        id       = lookup(step, "id", "")
        dir      = lookup(step, "dir", "")
        env      = lookup(step, "env", [])
        timeout  = lookup(step, "timeout", "")
        args     = local.args

        entrypoint = "/bin/sh"

      }]

      content {
        name = step.value.name
      }
    }
  }

  # filename      = "cloudbuild.yaml"
  substitutions = {}

  name           = "PUSH-test"
  description    = "what a lovely description"
  included_files = ["*"]
  ignored_files  = []

  github {
    # coalesce returns the first non empty string in the list
    owner = "cyclingwithelephants"
    name  = "terraform-modules"

    # one of pull_request and push !!
    push {
      # only specify one of branch and tag !!
      branch = ".*"
      # tag    = lookup(local.push, "commit_tag", ".*")
    }
  }
}

output "args" {
  value = local.args
}

output "push" {
  value = local.push
}

provider "google-beta" {
  project = var.project_id
  # region  = var.region
}
provider "google" {
  project = var.project_id
  # region  = var.region
}

variable "create_triggers" {
  description = "whether or not to create a trigger for each code change type"
  type        = map(bool)
  default = {
    push = true
  }
}

variable "project_id" {
  description = "the GCP project_id to create resources inside"
  type        = string
  default     = "home-247920"
}
