locals {
  pr = yamldecode(file("${path.module}/../instructions/${var.tool_name}/pr-cloudbuild.yaml"))
}

resource "google_cloudbuild_trigger" "pull_request" {
  provider = google-beta
  count    = var.create_triggers["pr"] == true ? 1 : 0

  build {
    dynamic "step" {
      for_each = [for step in local.pr.steps : {
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
  #   timeout = local.pr.timeout ? local.pr.timeout : ""
  #
  #   dynamic "step" {
  #     for_each = local.pr.steps
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
