included_files      = ["*"]
trigger_name        = "example-trigger"
trigger_description = <<-EOF
  This is a way to automatically add CI/CD to any piece of code, as long as it
  has the two supported build steps.
  EOF
github = {
  repo_owner = "Cyclingwithelephants"
  repo_name  = "terraform-modules"

}
substitutions = {}
