set -e

err() {
  echo >&2 "$1"
}

die() {
  err "$1"
  exit 1
}

check_env_vars() {
  local script_vars=("$@") # Capture all arguments as an array of required env var names
  local should_exit=0

  for variable_name in "${script_vars[@]}"; do
    if [ -z "${!variable_name}" ]; then # Dereference to get the value of the variable by name
      err "Required environment variable $variable_name is not set."
      should_exit=1
    fi
  done

  if [ $should_exit -eq 1 ]; then
    die "Exiting due to unset required environment variables."
  fi
}

lowercase() {
  tr '[:upper:]' '[:lower:]'
}

main() {
  # GITHUB_BRANCH is optional
  check_env_vars DOCKER_USERNAME GITHUB_REPO

  local image_name="$DOCKER_USERNAME/"
  local using_latest_tag=0

  if [ -n "$GITHUB_BRANCH" ]; then
    image_name="$image_name$GITHUB_BRANCH"_
  fi

  if [ -n "$GITHUB_REPO" ]; then
    image_name="$image_name$GITHUB_REPO"
    echo "Repository name is parsed"
  else
    die "Repository name is required"
  fi

  read -r image_name <<<"$(echo "$image_name" | lowercase)"

  echo "image-name=$image_name" >>$GITHUB_ENV

  if [ -n "$GITHUB_SHA" ]; then
    image_name="$image_name:$GITHUB_SHA"
    echo "SHA is parsed"
  else
    image_name="$image_name:latest"
    using_latest_tag="yes"
    echo "SHA is not available, using latest tag"
  fi

  read -r image_name <<<"$(echo "$image_name" | lowercase)"

  echo "tagged-image-name=$image_name" >>$GITHUB_ENV

  if [ $using_latest_tag -eq 0 ]; then
    echo "Successfully parsed image name using latest tag"
  else
    echo "Successfully parsed image name"
  fi

}

main
