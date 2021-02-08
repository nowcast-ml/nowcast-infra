#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o errtrace

function usage() {
    cat << EOF
Usage:
    generate_secrets.sh <resource> [<resource> .. <resource>]

Example:
    ./generate_secrets.sh cluster staging

EOF
}

if ! command -v git &> /dev/null; then
    echo "Error: git not found" >&2
    exit 1
fi

if ! command -v kubeseal &> /dev/null; then
    echo "Error: kubeseal not found" >&2
    exit 1
fi

timestamp() {
    date +"%T"
}

git_hash() {
    git rev-parse --verify HEAD
}

git_root() {
    git rev-parse --show-toplevel
}

GIT_ROOT="$(git_root)"
TARGET_PATH="${GIT_ROOT}/secrets"

for p in "$@"; do
    TARGET_PATH="${TARGET_PATH}/${p}"
done

if [ ! -d "${TARGET_PATH}" ]; then
    echo "Error: no resource \"${*:1}\"" >&2
    exit 1
fi

for t in `find "${TARGET_PATH}" -name "*.tpl" -type f`; do
    . "${t}"
    echo "generating sealed-secret at \"${TARGET_FILEPATH}\" with scope \"${TARGET_SCOPE}\" signed by \"${TARGET_CERT}\""
    echo "${TEMPLATE}" | kubeseal --format yaml --cert "${GIT_ROOT}/${TARGET_CERT}" --scope "${TARGET_SCOPE}" > "${GIT_ROOT}/${TARGET_FILEPATH}"
    unset TARGET_CERT; unset TARKET_SCOPE; unset TARGET_FILEPATH; unset TEMPLATE
done

