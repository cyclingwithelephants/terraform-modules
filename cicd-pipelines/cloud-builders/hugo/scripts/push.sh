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
### config
env=$(get_env)

[[ "${_BUCKET_NAME}" == "" ]] && echo "substitution _BUCKET_NAME not set, exiting now." && exit 1

### do things
hugo version

# build static website
hugo

# deploy static website to bucket if on master branch
[[ "${env}" == "prod" ]] && \
  gsutil rsync \
    -r \
    -m \
    ./public/ \
    ${_BUCKET_NAME}
