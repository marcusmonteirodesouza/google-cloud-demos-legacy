output "fhir_producer_sa_email" {
  value = google_service_account.fhir_producer.email
}

output "fhir_resource_creation_processing_sa_email" {
  value = google_service_account.fhir_resource_creation_processing_workflow.email
}