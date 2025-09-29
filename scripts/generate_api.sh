#!/bin/sh


instance=""
# Set base path to project root
BASE_PATH=$(dirname "$0")/..
cd "$BASE_PATH" || exit 1

# If the outout already exists, remove it
if [ -d "./packages/paperless_ngx_api_v9$instance" ]; then
    rm -rf ./packages/paperless_ngx_api_v9$instance
fi
openapi-generator generate \
  -i specs/paperless-ngx-api-v9.yaml \
  -g dart-dio \
  -o ./packages/paperless_ngx_api_v9$instance \
  --additional-properties=equalityCheckMethod=equatable,pubLibrary=paperless_ngx_api_v9,pubName=paperless_ngx_api_v9,serializationLibrary=json_serializable,packageName=paperless_ngx_api_v9,legacyDiscriminatorBehavior=false

cd ./packages/paperless_ngx_api_v9$instance || exit 1
fvm use 3.35.4
fvm dart pub get
fvm dart format .
fvm dart run build_runner build --delete-conflicting-outputs