data "google_pubsub_topic" "default_fhir_store_notifications" {
  name = var.default_fhir_store_notifications_pubsub_topic
}

resource "google_workflows_workflow" "fhir_resource_creation_processing" {
  name            = "fhir-resource-creation-processing"
  description     = "Process default FHIR store resource creation"
  region          = var.region
  service_account = var.fhir_resource_creation_processing_sa_email
  source_contents = <<-EOF
main:
    params: [event]
    steps:
        - log_event:
            call: sys.log
            args:
                text: $${event}
                severity: INFO
        - decode_pubsub_message:
            assign:
            - base64: $${base64.decode(event.data.message.data)}
            - message: $${text.decode(base64)}
        - return_pubsub_message:
                return: $${message}
EOF
}

resource "google_eventarc_trigger" "fhir_resource_creation_processing_workflow" {
  name     = "fhir-resource-creation-processing-workflow"
  location = google_workflows_workflow.fhir_resource_creation_processing.region

  destination {
    workflow = google_workflows_workflow.fhir_resource_creation_processing.id
  }

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }

  transport {
    pubsub {
      topic = data.google_pubsub_topic.default_fhir_store_notifications.id
    }
  }

  service_account = var.fhir_resource_creation_processing_sa_email
}