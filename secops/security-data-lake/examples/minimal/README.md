# Minimal Security Data Lake Example

This example creates a BigQuery-backed project-level security log sink without scheduled detections.

```bash
terraform init
terraform plan -var="project_id=demo-security-sandbox"
```

Use a dedicated sandbox project before applying. Keep `enable_scheduled_detections = false` until the exported log tables exist and query cost has been reviewed.
