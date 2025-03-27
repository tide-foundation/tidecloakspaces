#!/bin/bash
set -e

echo "🚀 [1/10] Cloning the Tidecloak Next.js client..."
git clone https://github.com/tide-foundation/tidecloak-client-nextJS.git

echo "📦 [2/10] Installing dependencies..."
cd tidecloak-client-nextJS
npm install
cd ..

echo "🌐 [3/10] Building Codespace URL for Next.js..."
CODESPACE_URL_NEXT="https://${CODESPACE_NAME}-3000.app.github.dev"
CODESPACE_URL_TC="https://${CODESPACE_NAME}-8080.app.github.dev"

echo "🔄 [4/10] Updating .devcontainer/test-realm.json with Codespace URL..."
sed -i "s|http://localhost:3000|${CODESPACE_URL_NEXT}|g" .devcontainer/test-realm.json
cp .devcontainer/test-realm.json tidecloak-client-nextJS/test-realm.json

echo "🐳 [5/10] Pulling and starting Tidecloak container..."
docker pull docker.io/tideorg/tidecloak-dev:latest
docker run -d \
  --name tidecloak \
  -p 8080:8080 \
  -e KC_HOSTNAME=${CODESPACE_URL_TC} \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=password \
  tideorg/tidecloak-dev:latest

echo "⏳ [6/10] Waiting for Tidecloak to become ready..."
until curl -s "${CODESPACE_URL_TC}/realms/master/.well-known/openid-configuration" > /dev/null; do
  sleep 2
  echo "⌛ Still waiting for Tidecloak..."
done

echo "🔐 [7/10] Fetching admin token..."
RESULT=$(curl -s --data "username=admin&password=password&grant_type=password&client_id=admin-cli" \
  "${CODESPACE_URL_TC}/realms/master/protocol/openid-connect/token")
TOKEN=$(echo "$RESULT" | sed 's/.*access_token":"//g' | sed 's/".*//g')

echo "🌍 [8/10] Creating realm using Admin API..."
curl -s -X POST "${CODESPACE_URL_TC}/admin/realms" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary @tidecloak-client-nextJS/test-realm.json

echo "📤 [9/10] Calling setUpTideRealm vendor endpoint..."
curl -s -X POST "${CODESPACE_URL_TC}/admin/realms/nextjs-test/vendorResources/setUpTideRealm" \
  -H "Authorization: Bearer $TOKEN" \
  -d "email=email@example.com"

echo "📥 [10/10] Fetching adapter config and writing to tidecloak.json..."
CLIENT_RESULT=$(curl -s -X GET \
  "${CODESPACE_URL_TC}/admin/realms/nextjs-test/clients?clientId=account" \
  -H "Authorization: Bearer $TOKEN")
CLIENT_UID=$(echo "$CLIENT_RESULT" | jq -r '.[0].id')

ADAPTER_RESULT=$(curl -s -X GET \
  "${CODESPACE_URL_TC}/admin/realms/nextjs-test/vendorResources/get-installations-provider?clientId=$CLIENT_UID&providerId=keycloak-oidc-keycloak-json" \
  -H "Authorization: Bearer $TOKEN")

echo "$ADAPTER_RESULT" > tidecloak-client-nextJS/tidecloak.json

echo "✅ Setup complete! Next.js app is ready with the dynamic Tidecloak config."
