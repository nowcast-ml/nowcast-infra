#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o errtrace


function usage() {
    cat << EOF
Usage:
    generate_cert.sh <private_key_filepath> <public_key_filepath> <manifest_filepath>

Example:
    ./generate_cert.sh private.key public.key secret.yaml

Env:
    \$SECRET_NAME - Name of the secret (default: sealed-secrets-main)
    \$SECRET_NAMESPACE - Namespace of the secret (default: kube-system)

EOF
}

function manifest_template() {
    cat << EOF
apiVersion: v1
kind: Secret
metadata:
  name: SECRET_NAME
  namespace: SECRET_NAMESPACE
  labels:
    sealedsecrets.bitnami.com/sealed-secrets-key: active
type: kubernetes.io/tls
data:
  tls.crt: SECRET_CRT
  tls.key: SECRET_KEY
EOF
}

SECRET_NAME="${SECRET_NAME:=sealed-secrets-main}"
SECRET_NAMESPACE="${SECRET_NAMESPACE:=kube-system}"

PRIVATE_KEY="${1-}"
PUBLIC_KEY="${2-}"
MANIFEST="${3-}"

if [ -z "${PRIVATE_KEY}" ] || [ -z "${PUBLIC_KEY}" ] || [ -z "${MANIFEST}" ]; then
    usage
    exit 1
fi

if ! command -v openssl &> /dev/null; then
    echo "Error: openssl not found" >&2
    exit 1
fi

if ! command -v sed &> /dev/null; then
    echo "Error: sed not found" >&2
    exit 1
fi

if ! command -v base64 &> /dev/null; then
    echo "Error: base64 not found" >&2
    exit 1
fi

openssl req -x509 -nodes -newkey rsa:4096 -keyout "${PRIVATE_KEY}" -out "${PUBLIC_KEY}" -subj "/CN=sealed-secret/O=sealed-secret"

manifest_template | \
    sed "s/SECRET_NAME$/${SECRET_NAME}/g" | \
    sed "s/SECRET_NAMESPACE$/${SECRET_NAMESPACE}/g" | \
    sed "s/SECRET_CRT$/`cat ${PUBLIC_KEY} | base64`/g" | \
    sed "s/SECRET_KEY$/`cat ${PRIVATE_KEY} | base64`/g" > "${MANIFEST}"
