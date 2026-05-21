SELECT
  protopayload_auditlog.authenticationInfo.principalEmail AS user,
  httpRequest.remoteIp AS source_ip,
  COUNT(*) AS failed_attempts,
  MIN(timestamp) AS first_attempt,
  MAX(timestamp) AS last_attempt
FROM
  `security_data_lake.cloudaudit_googleapis_com_activity_*`
WHERE
  protopayload_auditlog.status.code = 16
  AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
GROUP BY
  user, source_ip
HAVING
  failed_attempts > 20
ORDER BY
  failed_attempts DESC;

