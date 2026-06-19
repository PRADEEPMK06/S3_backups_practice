#!/bin/bash
# task-26/scripts/backup.sh - Automated S3 Backup Script

set -e

BUCKET_NAME="pradeep-task-26-backup-bucket"

# Get the absolute root directory of task-26
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

APP_DIR="${ROOT_DIR}/src"
CONFIG_DIR="${ROOT_DIR}/config"
BACKUP_TEMP_DIR="/tmp/app_backups"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILENAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="${BACKUP_TEMP_DIR}/${BACKUP_FILENAME}"

echo "Starting backup process..."
mkdir -p "${BACKUP_TEMP_DIR}"

# Archive both src and config directories cleanly
tar -czf "${BACKUP_PATH}" -C "${APP_DIR}" . -C "${CONFIG_DIR}" .

echo "Uploading backup archive to S3..."
aws s3 cp "${BACKUP_PATH}" "s3://${BUCKET_NAME}/backups/${BACKUP_FILENAME}"

rm -rf "${BACKUP_TEMP_DIR}"
echo "Backup process completed successfully."