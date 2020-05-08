# locals {
#   pr_steps = [
#     {
#       bash = <<-EOF
#               |
#
#
#               EOF
#
#     },
#   ]
# }
#
# resource "google_cloudbuild_trigger" "pull_request" {
#   count = var.create_triggers["pr"] == true ? 1 : 0
#
#   build {
#     steps {
#       dynamic "step" {
#         for_each = var.pr_steps
#         name     = each.name
#         id       = each.id ? each.id : ""
#
#
#         entrypoint = "/bin/bash"
#         env        = each.env ? each.env : []
#         args = [
#           "-c",
#           each.bash,
#         ]
#       }
#     }
#   }
#
#   timeouts {
#     create = var.timeouts["create"]
#     update = var.timeouts["update"]
#     delete = var.timeouts["delete"]
#   }
#
#   name           = var.trigger_name
#   description    = var.trigger_description
#   substitutions  = var.substitutions
#   included_files = var.included_files
#   ignored_files  = var.ignored_files
#
#   github {
#     owner = var.github["repo_owner"]
#     name  = var.github["repo_name"]
#     # one of pull_request and push !!
#     pull_request {
#       branch = var.github["branch"]
#     }
#     push {
#       # only specify one of branch and tag !!
#       branch = var.github["branch"]
#       tag    = var.github["commit_tag"]
#     }
#   }
# }
