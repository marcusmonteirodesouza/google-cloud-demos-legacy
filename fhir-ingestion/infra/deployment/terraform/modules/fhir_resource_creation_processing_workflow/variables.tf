variable "region" {
  type        = string
  description = "The default Google Cloud region for the created resources."
}

variable "fhir_resource_creation_processing_sa_email" {
  type        = string
  description = "The FHIR resource creation processing workflow service account email."
}

variable "default_fhir_store_notifications_pubsub_topic" {
  type        = string
  description = "The default FHIR store notifications pub/sub topic name."
}