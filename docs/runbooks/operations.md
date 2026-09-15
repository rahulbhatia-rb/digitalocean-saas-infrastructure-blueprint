# Core operations runbook

## Patching and vulnerability management

1. Review scan output and vendor advisories; classify urgency and affected assets.
2. Open a change record with scope, test evidence, window, validation, and rollback.
3. Rebuild the base image/container, pin the patched version, and scan the artifact.
4. Deploy to test, then staging; execute health, latency, error-rate, and business checks.
5. Obtain client approval before the production window. Emergency changes still require recorded approval.
6. Support the authorised promotion, validate metrics, retain scan/deployment evidence, and close the record.

## Administrative access

1. Require an approved ticket naming the person, system, role, justification, and expiry.
2. Provision an individual account/key with least privilege and an allow-listed access path.
3. Record the access change and verify login/audit events.
4. Revoke on expiry, role change, or termination; confirm removal in the ticket.
5. Review active administrative access at the agreed cadence.

## Backup restore test

1. Select a recent backup and create an isolated restore target with no production consumers.
2. Run `scripts/verify-postgres-restore.sh` with approved secret injection.
3. Verify schema/table counts and agreed application-level consistency checks.
4. Capture timestamps, checksum, logs, duration, and recovery-point variance.
5. Destroy the restore target after evidence review and log any corrective actions.

## Certificate renewal

1. Inventory certificates, issuers, domains, owners, and expiry dates.
2. Alert at 45, 30, 14, and 7 days before expiry.
3. Renew in test/staging and validate chain, hostname, protocol, and dependent integrations.
4. Schedule the approved production change with rollback to the previous certificate.
5. Validate externally and retain evidence.

## Incident response

1. Acknowledge, classify, assign an incident lead, and preserve logs/evidence.
2. Contain impact using the lowest-risk reversible action available.
3. Communicate status at the agreed severity cadence.
4. Recover, validate service indicators and business checks, then monitor for recurrence.
5. Complete the RCA and track corrective actions to closure.

