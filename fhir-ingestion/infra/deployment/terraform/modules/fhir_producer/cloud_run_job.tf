resource "random_uuid" "fhir_producer_data_bucket" {
}

resource "google_storage_bucket" "fhir_producer_data" {
  name     = random_uuid.fhir_producer_data_bucket.result
  location = var.region

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "fhir_producer_data_fhir_producer_sa" {
  bucket = google_storage_bucket.fhir_producer_data.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${var.fhir_producer_sa_email}"
}

resource "google_cloud_run_v2_job" "fhir_producer" {
  name     = "fhir-producer"
  location = var.region

  template {
    template {
      service_account = var.fhir_producer_sa_email

      containers {
        image = "${docker_registry_image.fhir_producer.name}@${docker_registry_image.fhir_producer.sha256_digest}"

        args = [
          google_storage_bucket.fhir_producer_data.url
        ]
      }
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }

  depends_on = [
    google_storage_bucket_iam_member.fhir_producer_data_fhir_producer_sa
  ]
}