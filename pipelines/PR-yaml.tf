locals {
}

resource "google_cloudbuild_trigger" "pull_request" {
  count = var.create_triggers["pr"] == true ? 1 : 0

  build {
    steps {
      dynamic "step" {
        for_each = yamldecode(file("${module.path}/${var.tool_name}/pr-cloudbuild.yaml")).pr.steps

        # mandatory
        name = each.name

        # optional
        wait_for = each.wait_for ? each.wait_for : ""
        id       = each.id ? each.id : ""
        dir      = each.dir ? each.dir : ""
        env      = each.env ? each.env : []
        timeout  = each.timeout ? each.timeout : ""
        volumes  = each.volumes ? each.volumes : []

        args = [
          "-c",
          each.bash,
        ]

        # Hardcoded to give this our cloudbuild files multiline bash abstraction using only |
        entrypoint = "/bin/bash"
      }
    }
  }

  timeouts {
    create = local.pr.timeouts["create"]
    update = local.pr.timeouts["update"]
    delete = local.pr.timeouts["delete"]
  }

  name           = local.pr.trigger_name
  description    = local.pr.trigger_description
  substitutions  = local.pr.substitutions
  included_files = local.pr.included_files
  ignored_files  = local.pr.ignored_files

  github {
    owner = var.github["repo_owner"] ? var.github["repo_owner"] : "ziglu"
    name  = var.github["repo_name"] ? var.github["repo_name"] : "ziglu"
    # one of pull_request and push !!
    pull_request {
      # coalesce returns the first non empty string in the list
      branch = coalesce(var.github["branch"], "*")
    }
    push {
      # only specify one of branch and tag !!
      branch = coalesce(var.github["branch"], "*")
      tag    = coalesce(var.github["commit_tag"], "*")
    }
  }
}
