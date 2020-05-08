these terraform modules will eventually pair with docker containers that will be used for the CI/CD process. The purpose of this module is to be able to configure a pipeline trigger and a CI process for a piece of code (e.g. running pieces of Terraform, or triggering bazel) without manually writing out the pipeline. Instead, the pipeline exists in a versioned way inside a "builder" container which has all the pipeline steps defined in it such as

```
$ tree /steps/

.
├── bazel
│   ├── pr
│   └── push
└── terraform
    ├── pr
    └── push
# for example
```

so that we can define what e.g. the PR pipeline for a piece of terraform code looks like once and apply it to everywhere that it is relevant. We can version this pipeline inside the docker image and also trigger the pipeline on a refresh of the pipeline so that the change process is tested along with the application and infrastructure every single time the code changes.

This system is extensible in that for any pipeline one can override the steps if necessary, or one can compose them before, after, or in between the steps as any component requires. Furthermore, this customisation of these pipelines is auditable to the point that we can see exactly what that change was, and by whom. This is all due to the terraform state history.

we can do this customisation as such
```Terraform
variable "pr_steps" {
  type = string
  default = <<-EOF
    # perhaps we get some secrets
    /steps/terraform/pr

    EOF
}
```
