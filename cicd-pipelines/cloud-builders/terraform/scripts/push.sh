source common.sh

############## Config
env="$(get_env)"
# if terraform org is empty, we are outisde cloudbuild and so we initiate this as a test
[[ "${_ORG}" == "" ]] && _ORG=cyclingwithelephants
if [[ "${_REPO_NAME}" == "" ]]; then
  export TF_VAR_repo_name=$(basename `git rev-parse --show-toplevel`)
else
  export TF_VAR_repo_name=${_REPO_NAME}
fi
############## Do things
setup_GCP_auth

terraform validate

# assumption is that every plan has a backend using the "prefix" attribute,
# making the actual workspace named "${prefix}${env}"
tf_setup_workspace "${env}"

terraform init

terraform plan \
  -out=./tfplan \

[[ "${env}" == "prod" ]] && \
  terraform apply \
    --auto-approve \
    --lock-timeout ${_TF_LOCK_TIMEOUT_MINS} \
    ./tfplan
