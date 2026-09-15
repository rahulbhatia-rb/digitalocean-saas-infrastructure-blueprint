#!/usr/bin/env sh
set -eu

: "${SOURCE_DATABASE_URL:?Set SOURCE_DATABASE_URL}"
: "${RESTORE_DATABASE_URL:?Set RESTORE_DATABASE_URL to an isolated test database}"

artifact_dir="${BACKUP_ARTIFACT_DIR:-./backup-artifacts}"
mkdir -p "$artifact_dir"
backup_file="$artifact_dir/backup-$(date -u +%Y%m%dT%H%M%SZ).dump"

pg_dump --format=custom --no-owner --dbname="$SOURCE_DATABASE_URL" --file="$backup_file"
pg_restore --clean --if-exists --no-owner --dbname="$RESTORE_DATABASE_URL" "$backup_file"

table_count=$(psql "$RESTORE_DATABASE_URL" -Atc "select count(*) from pg_catalog.pg_tables where schemaname not in ('pg_catalog','information_schema');")
test "$table_count" -gt 0
sha256sum "$backup_file" > "$backup_file.sha256"
printf 'Restore verified: %s application tables; evidence: %s\n' "$table_count" "$backup_file.sha256"

