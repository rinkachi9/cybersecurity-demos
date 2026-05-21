SELECT
  protopayload_auditlog.authenticationInfo.principalEmail AS actor,
  resource.labels.bucket_name AS bucket,
  SUM(CAST(JSON_VALUE(protopayload_auditlog.metadata, "$.numBytes") AS INT64)) AS total_bytes_transferred,
  COUNT(*) AS operations_count
FROM
  `security_data_lake.cloudaudit_googleapis_com_data_access_*`
WHERE
  protopayload_auditlog.methodName = "storage.objects.get"
  AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
GROUP BY
  actor, bucket
HAVING
  total_bytes_transferred > 1000000000
ORDER BY
  total_bytes_transferred DESC;

