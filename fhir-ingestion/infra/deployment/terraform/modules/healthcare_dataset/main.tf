resource "google_healthcare_dataset" "default" {
  name      = "${var.region}-default-dataset"
  location  = var.region
  time_zone = "UTC"
}

resource "google_healthcare_fhir_store" "default" {
  name    = "default-fhir-store"
  dataset = google_healthcare_dataset.default.id
  version = "R4"

  stream_configs {
    bigquery_destination {
      dataset_uri = "bq://${google_bigquery_dataset.default_fhir_store.project}.${google_bigquery_dataset.default_fhir_store.dataset_id}"
      schema_config {
        recursive_structure_depth = 2
      }
    }
  }
}

resource "google_bigquery_dataset" "default_fhir_store" {
  dataset_id                 = "default_fhir_store"
  description                = "${google_healthcare_dataset.default.name} default FHIR store streaming export dataset"
  location                   = var.region
  delete_contents_on_destroy = true
}