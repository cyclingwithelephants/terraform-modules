# output "pr_id" {
#   value       = google_cloudbuild_trigger.pull_request.id
#   description = <<-EOF
#     an identifier for the resource with format
#     projects/{{project}}/triggers/{{trigger_id}}
#     EOF
# }
#
# output "pr_trigger_id" {
#   value       = google_cloudbuild_trigger.pull_request.trigger_id[count.index]
#   description = "The unique identifier for the trigger."
# }
#
# output "pr_create_time" {
#   value       = google_cloudbuild_trigger.pull_request.create_time[count.index]
#   description = "Time when the trigger was created."
# }
# output "pr_cloudbuild_file_input" {
#   value       = local.pr
#   description = "how terraform renders the cloudbuild file it read."
# }
output "push" {
  value = google_cloudbuild_trigger.push
}

output "push_cloudbuild" {
  value = local.push
}
