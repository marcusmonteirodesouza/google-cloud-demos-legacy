const axios = require("axios").default;

async function run() {
  const projectId = "marcus-docai-tst-002";
  const locationId = "northamerica-northeast1";
  const datasetId = "northamerica-northeast1-default-dataset";
  const fhirStoreId = "default-fhir-store";

  const parent = `projects/${projectId}/locations/${locationId}/datasets/${datasetId}/fhirStores/${fhirStoreId}`;

  const token =
    "ya29.a0AfB_byASIjSCNIo0mk4u7rL1vegBMlgvLXAPoGMrTYziDmI6XRiAk6NUjeZjb7dtUTzF7Y5IEfJG50lBzWfDmS-9zSmLS0_F4Yy_bS_eYINhjWPBZQvWVF3v0LguwXLVdzRMtjasEabc1eX0A9eQ3vtO351h71mlKDIGcPNqqewaCgYKAb8SARESFQGOcNnCVeT8hdrzR-pNm-wOMdU42Q0178";

  const patientResource = await axios.post(
    `https://healthcare.googleapis.com/v1/projects/${projectId}/locations/${locationId}/datasets/${datasetId}/fhirStores/${fhirStoreId}/fhir/Patient`,
    {
      name: [{ use: "official", family: "Smith", given: ["Darcy"] }],
      gender: "female",
      birthDate: "1970-01-01",
      resourceType: "Patient",
    },
    {
      headers: {
        Authorization: `Bearer ${token}`,
        ContentType: "application/fhir+json",
      },
    },
  );
  console.log(`Created Patient resource with ID ${patientResource.data.id}`);
  console.log(JSON.stringify(patientResource.data));

  const encounterResource = await axios.post(
    `https://healthcare.googleapis.com/v1/projects/${projectId}/locations/${locationId}/datasets/${datasetId}/fhirStores/${fhirStoreId}/fhir/Encounter`,
    {
      status: "finished",
      class: {
        system: "http://hl7.org/fhir/v3/ActCode",
        code: "IMP",
        display: "inpatient encounter",
      },
      reasonCode: [
        {
          text: "The patient had an abnormal heart rate. She was concerned about this.",
        },
      ],
      subject: {
        reference: `Patient/${patientResource.data.id}`,
      },
      resourceType: "Encounter",
    },
    {
      headers: {
        Authorization: `Bearer ${token}`,
        ContentType: "application/fhir+json",
      },
    },
  );
  console.log(
    `Created Encounter resource with ID ${encounterResource.data.id}`,
  );
  console.log(encounterResource.data);

  const observationResource = await axios.post(
    `https://healthcare.googleapis.com/v1/projects/${projectId}/locations/${locationId}/datasets/${datasetId}/fhirStores/${fhirStoreId}/fhir/Observation`,
    {
      status: "final",
      subject: {
        reference: `Patient/${patientResource.data.id}`,
      },
      effectiveDateTime: "2020-01-01T00:00:00+00:00",

      identifier: [
        {
          system: "my-code-system",
          value: "ABC-12345",
        },
      ],
      code: {
        coding: [
          {
            system: "http://loinc.org",
            code: "8867-4",
            display: "Heart rate",
          },
        ],
      },
      valueQuantity: {
        value: 80,
        unit: "bpm",
      },
      encounter: {
        reference: `Encounter/${encounterResource.data.id}`,
      },
      resourceType: "Observation",
    },
    {
      headers: {
        Authorization: `Bearer ${token}`,
        ContentType: "application/fhir+json",
      },
    },
  );
  console.log(
    `Created Observation resource with ID ${observationResource.data.id}`,
  );
  console.log(observationResource.data);
}

run();
