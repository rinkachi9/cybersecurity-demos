# 05. Backup and Disaster Recovery

Backup is not just an archive. It is a security control that determines whether the organization can recover from ransomware, operator error, data deletion, regional failure, corruption, or a failed migration. Disaster Recovery describes how quickly and how completely a service can return after such an event.

## What are backup, DR, RPO, and RTO?

**Backup** is a copy of data that can be restored after the original data is lost, corrupted, encrypted, or deleted.

**Disaster Recovery (DR)** is the plan for restoring a system after a major technical failure, human error, or security incident.

The two most important planning metrics are:

- **RPO (Recovery Point Objective)**: how much data loss is acceptable, for example 15 minutes, 4 hours, or 24 hours.
- **RTO (Recovery Time Objective)**: how long the service can be unavailable, for example 1 hour, 8 hours, or 2 days.

Without RPO and RTO, backups are only technical copies, not a continuity plan.

## Architectural context

Backups must be designed for attacks, not only hardware failures. If an attacker compromises a project administrator, they may try to delete both production data and backups. Therefore backups should have:

- a separate permission model;
- retention and deletion protection;
- encryption aligned to data classification;
- access and deletion logging;
- regular restore tests;
- documentation of application dependencies.

## Threats and failure modes this protects against

- **Ransomware** that encrypts or destroys production data.
- **Insider threat** that deletes data or backup copies.
- **Operator error** during migration, cleanup, schema changes, or automation.
- **Regional failure** requiring recovery in another location.
- **Data corruption** detected after the initial write.
- **Broken automation** that modifies or deletes many resources at once.

## Implementation guidance for GCP

1. Define RPO and RTO for each critical system class.
2. Enable automated backups for Cloud SQL, AlloyDB, Spanner, and other managed services.
3. Use Object Versioning and retention policies for critical Cloud Storage buckets.
4. Consider Bucket Lock where immutable retention is required.
5. Replicate data across regions when the RTO requires regional resilience.
6. Separate permission to read backups from permission to delete backups.
7. Test restore regularly, not only backup configuration.
8. Document the recovery order: network, IAM, secrets, database, application, and DNS.

## DR strategy patterns

| Strategy | Use case | Cost | Recovery time |
| --- | --- | --- | --- |
| Backup and restore | less critical systems | low | longer |
| Pilot light | critical data with minimal standby infrastructure | medium | medium |
| Warm standby | services requiring faster recovery | higher | shorter |
| Active-active | very high availability systems | highest | shortest |

## Validation and evidence

Useful evidence includes:

- a restore test report with measured recovery time;
- proof that backups have retention and deletion protection;
- an inventory of identities allowed to delete backups;
- alerts for backup deletion, retention changes, or versioning disablement;
- a DR runbook with owners and escalation paths.

## Common mistakes

- Assuming service durability is the same as recoverable backup.
- Never testing restore, so backups fail during an incident.
- Keeping backups in the same project with the same administrators as production.
- Using retention that is too short for delayed ransomware detection.
- Backing up data but not IAM, secrets, infrastructure, and configuration.

## Checklist

- [ ] Every critical system has defined RPO and RTO.
- [ ] Backups are automated, encrypted, retained, and monitored.
- [ ] Backup deletion requires restricted permissions.
- [ ] Restore is tested regularly and documented.
- [ ] Alerts cover deletion, retention changes, and versioning disablement.
- [ ] The DR plan includes data, infrastructure, IAM, secrets, and application dependencies.

---
Reference: [Disaster recovery planning guide](https://cloud.google.com/architecture/disaster-recovery)
