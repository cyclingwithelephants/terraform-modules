resource "google_cloudbuild_trigger" "hugo-master" {
  name = ""
  description = ""

  github {
    owner =
    name =
    # one of
    # pull_request =
    # push =
  }

  pull_request {

  }

  push {

  }

  substitutions = {
    _ENV = var.env
  }

  included_files = var.included_files

  ignored_files = []

  build {
    steps {
      step {
        name = "hugo"

        entrypoint = "/bin/bash"
        secret_env = [""]
        args = [
          "-c",
          "|
            cd hugo

            hugo

            ,
        ]
      }
    }
  }
}
