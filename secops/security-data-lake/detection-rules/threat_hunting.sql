# Detection Engineering: SQL-based Threat Hunting (SIEM approach)
# These queries run on top of the Security Data Lake in BigQuery.

---
# 1. Detection: Brute Force Attempt (Multiple Failed Logins)
# Goal: Find any user or IP that has more than 20 failed login attempts in 1 hour.

SELECT
  protopayload_auditlog.authenticationInfo.principalEmail as user,
  httpRequest.remoteIp as source_ip,
  count(*) as failed_attempts,
  min(timestamp) as first_attempt,
  max(timestamp) as last_attempt
FROM
  `security_data_lake.cloudaudit_googleapis_com_activity_*`
WHERE
  protopayload_auditlog.status.code = 16 # Unauthenticated / Permission Denied
  AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
GROUP BY
  user, source_ip
HAVING
  failed_attempts > 20
ORDER BY
  failed_attempts DESC;

---
# 2. Detection: Network Beaconing (Suspicious Outbound Patterns)
# Goal: Detect if a VM is talking to a single external IP at very regular intervals.

WITH flow_stats AS (
  SELECT
    jsonPayload.connection.src_ip as src_vm,
    jsonPayload.connection.dest_ip as dest_ip,
    TIMESTAMP_TRUNC(timestamp, MINUTE) as time_window,
    count(*) as packet_count
  FROM
    `security_data_lake.compute_googleapis_com_vpc_flows_*`
  WHERE
    jsonPayload.reporter = "SRC"
    AND jsonPayload.connection.dest_ip NOT LIKE "10.%" # Exclude internal traffic
  GROUP BY
    src_vm, dest_ip, time_window
)
SELECT
  src_vm,
  dest_ip,
  stddev(packet_count) as packet_variability,
  count(distinct time_window) as active_minutes
FROM
  flow_stats
GROUP BY
  src_vm, dest_ip
HAVING
  active_minutes > 10 AND packet_variability < 1.5
ORDER BY
  active_minutes DESC;

---
# 3. Detection: GCS Data Exfiltration (Large External Transfers)
# Goal: Find service accounts or users transferring unusually large amounts of data out of GCS.

SELECT
  protopayload_auditlog.authenticationInfo.principalEmail as actor,
  resource.labels.bucket_name as bucket,
  sum(cast(JSON_VALUE(protopayload_auditlog.metadata, "$.numBytes") as int64)) as total_bytes_transferred,
  count(*) as operations_count
FROM
  `security_data_lake.cloudaudit_googleapis_com_data_access_*`
WHERE
  protopayload_auditlog.methodName = "storage.objects.get"
  AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
GROUP BY
  actor, bucket
HAVING
  total_bytes_transferred > 1000000000 # 1GB (adjust threshold as needed)
ORDER BY
  total_bytes_transferred DESC;
