locals {
  fhir_resource_creation_processing_workflow_sa_roles = [
    "roles/logging.logWriter",
    "roles/workflows.invoker"
  ]
}

resource "google_service_account" "fhir_resource_creation_processing_workflow" {
  account_id   = "fhir-rsrc-creat-proc-wrkflw-sa"
  display_name = "FHIR resource creation processing workflow service account"
}

resource "google_project_iam_member" "fhir_resource_creation_processing_workflow_sa" {
  for_each = toset(local.fhir_resource_creation_processing_workflow_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.fhir_resource_creation_processing_workflow.email}"
}