locals {
  fhir_producer_directory  = "${path.module}/../../../../../fhir-producer"
  fhir_producer_repository = "${var.region}-docker.pkg.dev/${data.google_project.project.project_id}/${google_artifact_registry_repository.fhir_producer.name}"
  fhir_producer_image      = "${local.fhir_producer_repository}/fhir-producer"
}

resource "google_artifact_registry_repository" "fhir_producer" {
  location      = var.region
  repository_id = "fhir-producer-repo"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "fhir_producer_sa" {
  location   = google_artifact_registry_repository.fhir_producer.location
  repository = google_artifact_registry_repository.fhir_producer.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.fhir_producer_sa_email}"
}

resource "docker_image" "fhir_producer" {
  name = local.fhir_producer_image
  build {
    context = local.fhir_producer_directory
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(local.fhir_producer_directory, "**") : filesha1("${local.fhir_producer_directory}/${f}")]))
  }
}

resource "docker_registry_image" "fhir_producer" {
  name = docker_image.fhir_producer.name
}
