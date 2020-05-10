
source common.sh

############## Config
# If we are not running in cloudbuild, get our repo name the old fashioned way
if [[ "${_REPO_NAME}" == "" ]]; then
  TF_VAR_repo_name=$(basename `git rev-parse --show-toplevel`)
else
  TF_VAR_repo_name=${_REPO_NAME}
fi


############## Do things
setup_GCP_auth

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
