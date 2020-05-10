# Sets up a terraform workspace without remote execution activated
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
           --header "Authorization: Bearer $token" \
           --header "Content-Type: application/vnd.api+json" \
           --data '{"data":{"attributes":{"operations":false}}}' \
           --url https://app.terraform.io/api/v2/organizations/${_ORG}/workspaces/"${ws}" \
           -s # stops showing download progress
}

# infers the environment based off of the current branch, using variables
# from cloudbuild if available
function get_env() {
  # BRANCH_NAME is a cloudbuild built-in variable
  if [[ ${BRANCH_NAME} ]]; then
    if [[ ${BRANCH_NAME} == "master" ]]; then
      env='prod'
    else
      # _PR_NUMBER is a github cloudbuild built-in
      env="dev-${BRANCH_NAME}"
    fi
  else # is being executed locally
    branch_name=$(git symbolic-ref --short HEAD)
    if [[ ${branch_name} == "master" ]]; then
      env='prod'
    else
      env="dev-${branch_name}"
    fi
  fi
  echo ${env}
}

# if we're running inside cloudbuild, we want to set up authentication with GCP
# so that we can build things with terraform
function setup_GCP_auth() {
  active_account=""
  function get-active-account() {
    active_account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2> /dev/null)
  }

  function activate-service-key() {
    rootdir=/root/.config/gcloud-config
    mkdir -p $rootdir
    tmpdir=$(mktemp -d "$rootdir/servicekey.XXXXXXXX")
    trap "rm -rf $tmpdir" EXIT
    echo ${GCLOUD_SERVICE_KEY} | base64 --decode -i > ${tmpdir}/gcloud-service-key.json
    gcloud auth activate-service-account --key-file ${tmpdir}/gcloud-service-key.json --quiet
    get-active-account
  }

  function service-account-usage() {
    cat <<EOF
No account is set. This is either provided by the Google cloud builder environment, or by providing a
key file through environment variables, e.g. set
  GCLOUD_SERVICE_KEY=<base64 encoded service account key file>
EOF
  exit 1
}

  function account-active-warning() {
    cat <<EOF
A service account key file has been provided in the environment variable GCLOUD_SERVICE_KEY. This account will
be activated, which will override the account already activated in this container.
This usually happens if you've defined the GCLOUD_SERVICE_KEY environment variable in a cloudbuild.yaml file & this is
executing in a Google cloud builder environment.
EOF
}

  get-active-account
  if [[ (! -z "$active_account") &&  (! -z "$GCLOUD_SERVICE_KEY") ]]; then
    account-active-warning
    activate-service-key
  elif [[ (-z "$active_account") && (! -z "$GCLOUD_SERVICE_KEY") ]]; then
    activate-service-key
  elif [[ (-z "$active_account") &&  (-z "$GCLOUD_SERVICE_KEY") ]]; then
    echo "no active account and no key"
    service-account-usage
  fi
}
