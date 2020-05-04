output "google_function_name" {
  description = "The name of the Google function."
  value       = "${google_cloudfunctions_function.function.name}"
}
