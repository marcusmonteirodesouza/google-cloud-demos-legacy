locals {
  fhir_producer_sa_roles = [
  ]
}

resource "google_service_account" "fhir_producer" {
  account_id   = "fhir-producer-sa"
  display_name = "FHIR Producer Service Account"
}

resource "google_project_iam_member" "fhir_producer_sa" {
  for_each = toset(local.fhir_producer_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.fhir_producer.email}"
}