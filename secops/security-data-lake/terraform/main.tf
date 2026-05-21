locals {
  sink_destination = "bigquery.googleapis.com/${google_bigquery_dataset.security_logs.id}"

  log_sink_writer_identity = concat(
    google_logging_organization_sink.security_logs[*].writer_identity,
    google_logging_folder_sink.security_logs[*].writer_identity,
    google_logging_project_sink.security_logs[*].writer_identity,
  )[0]

  log_sink_name = concat(
    google_logging_organization_sink.security_logs[*].name,
    google_logging_folder_sink.security_logs[*].name,
    google_logging_project_sink.security_logs[*].name,
  )[0]

  required_services = toset([
    "bigquery.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "logging.googleapis.com",
  ])

  scheduled_detection_queries = {
    brute_force_login = {
      display_name      = "Security detection: brute force login"
      query_path        = "${path.module}/../detections/brute-force-login/query.sql"
      destination_table = "detection_brute_force_login"
    }
    low_and_slow_beaconing = {
      display_name      = "Security detection: low and slow beaconing"
      query_path        = "${path.module}/../detections/low-and-slow-beaconing/query.sql"
      destination_table = "detection_low_and_slow_beaconing"
    }
    gcs_data_exfiltration = {
      display_name      = "Security detection: GCS data exfiltration"
      query_path        = "${path.module}/../detections/gcs-data-exfiltration/query.sql"
      destination_table = "detection_gcs_data_exfiltration"
    }
  }

  enabled_scheduled_detection_queries = var.enable_scheduled_detections ? {
    for detection_id, detection in local.scheduled_detection_queries : detection_id => detection
    if contains(var.enabled_detection_ids, detection_id)
  } : {}
}

resource "google_project_service" "required" {
  for_each = var.enable_required_services ? local.required_services : toset([])

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "google_bigquery_dataset" "security_logs" {
  project                    = var.project_id
  dataset_id                 = var.dataset_id
  friendly_name              = var.dataset_friendly_name
  description                = var.dataset_description
  location                   = var.location
  delete_contents_on_destroy = var.delete_contents_on_destroy
  labels                     = var.labels

  dynamic "default_encryption_configuration" {
    for_each = var.kms_key_name == "" ? [] : [var.kms_key_name]

    content {
      kms_key_name = default_encryption_configuration.value
    }
  }

  depends_on = [google_project_service.required]
}

resource "google_logging_organization_sink" "security_logs" {
  count = var.sink_scope == "organization" ? 1 : 0

  name                   = var.sink_name
  description            = var.sink_description
  org_id                 = var.organization_id
  destination            = local.sink_destination
  filter                 = var.log_sink_filter
  include_children       = var.include_children
  unique_writer_identity = true

  bigquery_options {
    use_partitioned_tables = var.use_partitioned_log_tables
  }

  depends_on = [google_bigquery_dataset.security_logs]
}

resource "google_logging_folder_sink" "security_logs" {
  count = var.sink_scope == "folder" ? 1 : 0

  name                   = var.sink_name
  description            = var.sink_description
  folder                 = var.folder_id
  destination            = local.sink_destination
  filter                 = var.log_sink_filter
  include_children       = var.include_children
  unique_writer_identity = true

  bigquery_options {
    use_partitioned_tables = var.use_partitioned_log_tables
  }

  depends_on = [google_bigquery_dataset.security_logs]
}

resource "google_logging_project_sink" "security_logs" {
  count = var.sink_scope == "project" ? 1 : 0

  name                   = var.sink_name
  description            = var.sink_description
  project                = var.sink_project_id == "" ? var.project_id : var.sink_project_id
  destination            = local.sink_destination
  filter                 = var.log_sink_filter
  unique_writer_identity = true

  bigquery_options {
    use_partitioned_tables = var.use_partitioned_log_tables
  }

  depends_on = [google_bigquery_dataset.security_logs]
}

resource "google_bigquery_dataset_iam_member" "log_sink_writer" {
  count = var.grant_log_sink_writer ? 1 : 0

  project    = var.project_id
  dataset_id = google_bigquery_dataset.security_logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = local.log_sink_writer_identity
}

resource "google_bigquery_data_transfer_config" "scheduled_detection" {
  for_each = local.enabled_scheduled_detection_queries

  project                = var.project_id
  location               = var.location
  display_name           = each.value.display_name
  data_source_id         = "scheduled_query"
  schedule               = var.detection_schedule
  destination_dataset_id = google_bigquery_dataset.security_logs.dataset_id
  service_account_name   = var.scheduled_query_service_account_email == "" ? null : var.scheduled_query_service_account_email

  params = {
    query                           = replace(file(each.value.query_path), "`security_data_lake.", "`${var.project_id}.${var.dataset_id}.")
    destination_table_name_template = each.value.destination_table
    write_disposition               = "WRITE_TRUNCATE"
  }

  depends_on = [google_project_service.required]
}
