set -e

err() {
  echo >&2 "$1"
}

die() {
  err "$1"
  exit 1
}

lowercase() {
  tr '[:upper:]' '[:lower:]'
}

main() {
  local secret_count=0
  local secrets_dir="$(mktemp -d)/alvelive-build-secrets"

  mkdir -m 700 -p "$secrets_dir"

  if [ -n "$GITHUB_USERNAME" ]; then
    echo "$GITHUB_USERNAME" >"$secrets_dir/github_username"
    echo "GitHub username written to secrets as github_username"

    secret_count=$((secret_count + 1))
  fi

  if [ -n "$GITHUB_TOKEN" ]; then
    echo "$GITHUB_TOKEN" >"$secrets_dir/github_pat"
    echo "GitHub token written to secrets as github_pat"

    secret_count=$((secret_count + 1))
  fi

  if [ -n "$NPMRC" ]; then
    echo "$NPMRC" >"$secrets_dir/npmrc"
    echo "NPMRC written to secrets as npmrc"

    secret_count=$((secret_count + 1))
  fi

  if [ -n "$BUNFIG" ]; then
    echo "$BUNFIG" >"$secrets_dir/bunfig"
    echo "bunfig.toml written to secrets as bunfig"

    secret_count=$((secret_count + 1))
  fi

  if [ $secret_count -eq 0 ]; then
    echo "No secrets were provided"
  else
    echo "$secret_count secrets written to secrets directory"
  fi

  echo "alvelive-secrets-dir=$secrets_dir" >>$GITHUB_ENV
}

main
