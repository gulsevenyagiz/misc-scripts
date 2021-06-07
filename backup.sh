#!/usr/bin/env bash

# backup.sh
# This script creates zip's a given folder and pushes to S3.
# Requires S3 write perissions on the host.
#
set -e pipefail

readonly TAR="$(command -v tar)"
if [[ -z "${TAR}" ]]
    then
        echo "[!!!] Error: tar  binary not found. Aborting."
        exit 1
fi

readonly AWS="$(command -v aws)"
if [[ -z "${AWS}" ]]
    then
        echo "[!!!] Error: aws  binary not found. Aborting."
        exit 1
fi

readonly NOW="$(date +'%d-%m-%y')"

readonly DESTINATION_FOLDER=''

readonly S3_BUCKET_NAME=''

"${TAR}" -c  "${DESTINATION_FOLDER}" | "${AWS}" s3 cp - "${S3_BUCKET_NAME}""${NOW}".tar
