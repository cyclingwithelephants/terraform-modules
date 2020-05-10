locals {
  push = var.cloudbuild_overrides.push != "" ? yamldecode(file(var.cloudbuild_overrides.push)) : yamldecode(file("${path.module}/./instructions/${var.tool_name}/push-cloudbuild.yaml"))
}

resource "google_cloudbuild_trigger" "push" {
  provider = google-beta
  count    = var.create_triggers["push"] == true ? 1 : 0



  build {
    timeout = "3600s"

    dynamic "step" {
      for_each = [for step in local.push.steps : {
        name       = lookup(step, "name", "")
        args       = lookup(step, "args", [])
        sh         = lookup(step, "sh", "")
        env        = lookup(step, "env", [])
        dir        = var.starting_directory_overrides.push != "" ? var.starting_directory_overrides.push : lookup(step, "dir", "./${var.tool_name}")
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

  # filename      = "cloudbuild.yaml"
  substitutions = lookup(local.push, "substitutions", {})

  name           = "PUSH-${var.trigger_name}"
  description    = var.trigger_description
  included_files = var.included_files
  ignored_files  = var.ignored_files

  github {
    # coalesce returns the first non empty string in the list
    owner = lookup(var.github, "repo_owner", "")
    name  = lookup(var.github, "repo_name", "")

    # one of pull_request and push !!
    push {
      # only specify one of branch and tag !!
      branch = lookup(local.push, "branch", ".*")
      # tag    = lookup(local.push, "commit_tag", ".*")
    }
  }
}
