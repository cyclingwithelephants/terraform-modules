locals {
  pr = var.cloudbuild_overrides.pr != "" ? yamldecode(file(var.cloudbuild_overrides.pr)) : yamldecode(file("${path.module}/./instructions/${var.tool_name}/pr-cloudbuild.yaml"))
}

resource "google_cloudbuild_trigger" "pull_request" {
  provider = google-beta
  count    = var.create_triggers["pr"] == true ? 1 : 0

  build {
    timeout = "3600s"

    dynamic "step" {
      for_each = [for step in local.pr.steps : {
        name       = lookup(step, "name", "")
        args       = lookup(step, "args", [])
        sh         = lookup(step, "sh", "")
        env        = lookup(step, "env", [])
        dir        = var.starting_directory_overrides.pr != "" ? var.starting_directory_overrides.pr : lookup(step, "dir", "./${var.tool_name}")
        id         = lookup(step, "id", "")
        wait_for   = lookup(step, "wait_for", [])
        entrypoint = lookup(step, "entrypoint", "/bin/sh")
        secret_env = lookup(step, "secret_env", [])
        timeout    = lookup(step, "timeout", "600s")

        # volumes    = lookup(step, "volumes", {})
      }]

      content {
        name       = step.value.name
        args       = step.value.args == [] ? ["-c", step.value.sh, ] : step.value.args
        env        = step.value.env
        dir        = step.value.dir
        id         = step.value.id
        wait_for   = step.value.wait_for
        entrypoint = step.value.entrypoint
        secret_env = step.value.secret_env
        timeout    = step.value.timeout

        # volumes currently isn't working for me
        # TODO: get volumes hooked up to this
        # volumes {
        #   name = step.value.volumes.name
        #   path = step.value.volumes.path
        # }
      }
    }
  }

  substitutions = lookup(local.pr, "substitutions", {})

  name           = "PR-${var.trigger_name}"
  description    = var.trigger_description
  included_files = var.included_files
  ignored_files  = var.ignored_files

  github {
    # coalesce returns the first non empty string in the list
    owner = lookup(var.github, "repo_owner", "Cyclingwithelephants")
    name  = lookup(var.github, "repo_name", "terraform-modules")

    # one of pull_request and push !!
    pull_request {
      branch = lookup(var.github, "branch", ".*")
    }
  }
}
