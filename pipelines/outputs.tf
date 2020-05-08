output "id" {
  value       = google_cloudbuild_trigger.pull_request.id
  description = "an identifier for the resource with format projects/{{project}}/triggers/{{trigger_id}}"
}

output "trigger_id" {
  value       = google_cloudbuild_trigger.pull_request.trigger_id
  description = "The unique identifier for the trigger"
}

output "create_time" {
  value       = google_cloudbuild_trigger.pull_request.create_time
  description = "Time when the trigger was created"
}
