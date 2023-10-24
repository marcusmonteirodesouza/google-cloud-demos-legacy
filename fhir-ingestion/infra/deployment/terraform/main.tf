provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

provider "docker" {
  registry_auth {
    address  = "${var.region}-docker.pkg.dev"
    username = "oauth2accesstoken"
    password = data.google_client_config.default.access_token
  }
}

data "google_client_config" "default" {
}

module "enable_apis" {
  source = "./modules/enable_apis"
}

module "iam" {
  source = "./modules/iam"

  depends_on = [
    module.enable_apis
  ]
}

module "fhir_producer" {
  source = "./modules/fhir_producer"

  region                 = var.region
  fhir_producer_sa_email = module.iam.fhir_producer_sa_email
}

module "healthcare" {
  source = "./modules/healthcare_dataset"

  region = var.region

  depends_on = [
    module.iam
  ]
}

module "fhir_resource_creation_processing_workflow" {
  source = "./modules/fhir_resource_creation_processing_workflow"

  region                                        = var.region
  fhir_resource_creation_processing_sa_email    = module.iam.fhir_resource_creation_processing_sa_email
  default_fhir_store_notifications_pubsub_topic = module.healthcare.default_fhir_store_notifications_pubsub_topic
}