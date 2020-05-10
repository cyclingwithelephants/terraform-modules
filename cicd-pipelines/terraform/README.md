```terraform
module "terraform_cicd" {
  source = "github.com/cyclingwithelephants/terraform-modules/cicd-pipelines/terraform"

  # specify the name of the tool to apply cicd to, e.g. go, terraform, hugo etc
  tool_name = ""

  # This is the path to create triggers from if you are not storing your code in /${tool_name}
  # code_directory_override = ""
}
```
