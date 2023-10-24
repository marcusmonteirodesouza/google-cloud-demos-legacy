locals {
  healthcare_sa_roles = [
    "roles/bigquery.dataEditor",
    "roles/bigquery.jobUser"
  ]
}

resource "google_project_service_identity" "healthcare" {
  provider = google-beta
  service  = "healthcare.googleapis.com"
}

resource "google_project_iam_member" "healthcare_sa" {
  for_each = toset(local.healthcare_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_project_service_identity.healthcare.email}"
}