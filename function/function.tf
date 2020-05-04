resource "google_cloudfunctions_function" "function" {
  name                  = "${var.function_name}"
  description           = "${var.description}"
  available_memory_mb   = "${var.memory_mb}"
  timeout               = "${var.timeout}"
  runtime               = "${var.runtime}"

  trigger_http          = "${var.trigger_http}"
  entry_point           = "${var.entry_point}"

  # source_archive_bucket = "${google_storage_bucket.bucket.name}"
  # source_archive_object = "${google_storage_bucket_object.function.name}"

  labels                = "${var.labels}"
  environment_variables = "${var.environment_variables}"

  project = "${var.project_id}"
  region  = "${var.region}"

  source_repository {
    url = "${var.source_repository_url}"
  }
}

resource "google_storage_bucket" "functions" {
  name = "${var.function_name}-bucket-${var.labels["env"]}"
}

# resource "google_storage_bucket_object" "function" {
#   name   = "${var.function_zipfile_name}"
#   bucket = "${google_storage_bucket.functions.name}"
#   source = "${var.local_path_to_zipfile}"
# }
