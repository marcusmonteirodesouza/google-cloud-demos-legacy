#!/bin/bash

set -euxo pipefail

FILENAME="./src/main/resources/synthea.properties"
SEARCH="exporter.fhir.bulk_data = false"
REPLACE="exporter.fhir.bulk_data = true"
sed -i -e "s/$SEARCH/$REPLACE/g" "$FILENAME"