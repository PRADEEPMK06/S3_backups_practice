#!/bin/bash
# task-26/scripts/restore.sh - Disaster Recovery / Restore Process Demonstration

set -e

BUCKET_NAME="pradeep-task-26-backup-bucket"
RESTORE_DIR="/tmp/app_restore"

echo "Initiating restore demonstration..."
mkdir -p "${RESTORE_DIR}"

echo "Locating latest backup in S3..."
LATEST_BACKUP=$(aws s3api list-objects-v2 \
    --bucket "${BUCKET_NAME}" \
    --prefix "backups/" \
    --query 'sort_by(Contents, &LastModified)[-1].Key' \
    --output text)

if [ "${LATEST_BACKUP}" == "None" ] || [ -z "${LATEST_BACKUP}" ]; then
    echo "Error: No backups found in bucket ${BUCKET_NAME}."
    exit 1
fi

echo "Downloading ${LATEST_BACKUP} from S3..."
aws s3 cp "s3://${BUCKET_NAME}/${LATEST_BACKUP}" "${RESTORE_DIR}/latest_backup.tar.gz"

echo "Extracting files to verification directory..."
tar -xzf "${RESTORE_DIR}/latest_backup.tar.gz" -C "${RESTORE_DIR}"
rm "${RESTORE_DIR}/latest_backup.tar.gz"

echo "Restore demonstration completed successfully. Files inside ${RESTORE_DIR}:"
ls -la "${RESTORE_DIR}"