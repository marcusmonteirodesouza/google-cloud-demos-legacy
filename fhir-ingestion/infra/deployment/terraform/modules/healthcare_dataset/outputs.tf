output "default_fhir_store_notifications_pubsub_topic" {
  value = google_pubsub_topic.default_fhir_store_notifications.name
}