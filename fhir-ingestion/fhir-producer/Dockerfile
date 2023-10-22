FROM bitnami/git as git-clone-synthea

WORKDIR /workspace

RUN git clone https://github.com/synthetichealth/synthea.git

FROM eclipse-temurin:17 as run-synthea

COPY --from=git-clone-synthea /workspace/synthea /workspace/synthea

WORKDIR /workspace/synthea

COPY synthea_enable_bulk_data.sh .

RUN chmod +x synthea_enable_bulk_data.sh

RUN ./synthea_enable_bulk_data.sh

RUN ./run_synthea -p 10

FROM google/cloud-sdk

COPY --from=run-synthea /workspace/synthea/output /workspace/synthea/output

WORKDIR /workspace/synthea/output/fhir

ENTRYPOINT ["gcloud", "storage", "cp", "*.ndjson"]