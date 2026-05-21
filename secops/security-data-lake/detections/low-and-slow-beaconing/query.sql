WITH flow_stats AS (
  SELECT
    jsonPayload.connection.src_ip AS src_vm,
    jsonPayload.connection.dest_ip AS dest_ip,
    TIMESTAMP_TRUNC(timestamp, MINUTE) AS time_window,
    COUNT(*) AS packet_count
  FROM
    `security_data_lake.compute_googleapis_com_vpc_flows_*`
  WHERE
    jsonPayload.reporter = "SRC"
    AND NOT STARTS_WITH(jsonPayload.connection.dest_ip, "10.")
  GROUP BY
    src_vm, dest_ip, time_window
)
SELECT
  src_vm,
  dest_ip,
  STDDEV(packet_count) AS packet_variability,
  COUNT(DISTINCT time_window) AS active_minutes
FROM
  flow_stats
GROUP BY
  src_vm, dest_ip
HAVING
  active_minutes > 10
  AND packet_variability < 1.5
ORDER BY
  active_minutes DESC;

