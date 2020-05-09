locals {
  push = yamldecode(file("${path.module}/../instructions/${var.tool_name}/push-cloudbuild.yaml"))
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
        # volumes  = each.volumes ? each.volumes : []

        # if there is an argument variable given in cloudbuild
        #   use that for the step.
        # else if there is an argument variable given in cloudbuild named 'bash'
        #   use that for the step
        # else
        #   just pass an empty string and return an error
        args = lookup(step, "args", []) != [] ? lookup(step, "args", []) : ["-c", lookup(step, "bash", "echo 'If this is running in cloudbuild your BASH command hasn't come through terraform for some reason.")]

        # this gives our cloudbuild files multiline bash abstraction using
        # only the '|' symbol as per YAML spec.
        # still allows one to override with cloudbuild at any time
        entrypoint = lookup(step, "entrypoint", "/bin/bash")
      }]

      content {
        name = step.value.name
      }
    }
  }
  # build {
  #   timeout = local.push.timeout ? local.push.timeout : ""
  #
  #   dynamic "step" {
  #     for_each = local.push.steps
  #
  #     content {
  #       # mandatory
  #       name = each.name
  #
  #       # optional
  #
  #     }
  #   }
  # }

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
      branch = lookup(local.push, "branch", ".")
      # tag    = lookup(local.push, "commit_tag", ".*")
    }
  }
}
