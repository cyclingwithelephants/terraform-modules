function tf_setup_workspace() {
    env=$1

    token=$(cat ~/.terraform.d/credentials.tfrc.json | jq --raw-output '.credentials."app.terraform.io".token')
    prefix=$(cat terraform.tf | hclq get --raw 'terraform.backend.remote.workspaces.prefix')
    ws="${prefix}${env}"

    # gets workspace if it exists, creates it if it doesn't already
    terraform workspace select "${env}" 2>/dev/null || $(terraform workspace new ${env} && curl="true")

    # turns off the remote-excute function on terraform when we create a new workspace
    [[ "${curl}" == "true" ]] && \
      curl --request PATCH \
           --header "Authorization: Bearer ${token}" \
           --header "Content-Type: application/vnd.api+json" \
           --data '{"data":{"attributes":{"operations":false}}}' \
           --url https://app.terraform.io/api/v2/organizations/${_ORG}/workspaces/"${ws}" \
           -s # stops showing download progress
}

function running_locally() {
[[ "${_PR_NUMBER}" != "" ]] && return "true"
}

############## Config
if [[ "${_REPO_NAME}" == "" ]]; then
  TF_VAR_repo_name=$(basename `git rev-parse --show-toplevel`)
else
  TF_VAR_repo_name=${_REPO_NAME}
fi


############## Do things

# We get the most up to date version of the rebase branch so
# that we can create a plan based off of that
# BASE_BRANCH is a cloudbuild builtin for github PR's
git pull --rebase origin ${BASE_BRANCH}

terraform validate

# set up own workspace for PR, creating canary of this infra
tf_setup_workspace "prod-PR-${_PR_NUMBER}"

terraform init

terraform plan \
  -out=./tfplan


terraform apply \
  --auto-approve \
  --lock-timeout ${_TF_LOCK_TIMEOUT_MINS} \
  ./tfplan

# this is where we execute tests lol

terraform destroy \
  --auto-approve
