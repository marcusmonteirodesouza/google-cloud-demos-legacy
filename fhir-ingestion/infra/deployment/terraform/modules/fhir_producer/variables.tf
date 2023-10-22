variable "region" {
  type        = string
  description = "The default Google Cloud region for the created resources."
}

variable "fhir_producer_sa_email" {
  type        = string
  description = "The FHIR Producer Service Account email."
}