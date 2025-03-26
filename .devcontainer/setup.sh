#!/bin/bash
set -e

echo "🚀 [1/9] Cloning the Tidecloak Next.js client..."
git clone https://github.com/tide-foundation/tidecloak-client-nextJS.git

echo "📦 [2/9] Installing dependencies..."
cd tidecloak-client-nextJS
npm install
cd ..

echo "🌐 [3/9] Building Codespace URLs..."
CODESPACE_URL_NEXT="https://${CODESPACE_NAME}-3000.app.github.dev"
CODESPACE_URL_TC="https://${CODESPACE_NAME}-8080.app.github.dev"

echo "🔄 [4/9] Updating .devcontainer/test-realm.json with Codespace URL..."
sed -i "s|http://localhost:3000|${CODESPACE_URL_NEXT}|g" .devcontainer/test-realm.json
cp .devcontainer/test-realm.json tidecloak-client-nextJS/test-realm.json

echo "🐳 [5/9] Pulling and starting Docker container..."
docker pull docker.io/tideorg/tidecloak-dev:latest
docker run -d \
  -v "$(pwd)":/opt/keycloak/data/h2 \
  -v "$(pwd)/tidecloak-client-nextJS/test-realm.json":/opt/keycloak/data/import/test-realm.json \
  --name tidecloak \
  -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=password \
  tideorg/tidecloak-dev:latest

echo "🔐 [6/9] Fetching admin token..."
TOKEN=$(curl -s --data "username=admin&password=password&grant_type=password&client_id=admin-cli" \
  "${CODESPACE_URL_TC}/realms/master/protocol/openid-connect/token" | jq -r '.access_token')

echo "📤 [7/9] Setting up Tidecloak vendor resources..."
curl -X POST "${CODESPACE_URL_TC}/admin/realms/nextjs-test/vendorResources/setUpTideRealm" \
  -H "Authorization: Bearer $TOKEN" \
  -d "email=email@example.com"

echo "🔎 [8/9] Retrieving client UID for 'account' client..."
CLIENT_RESULT=$(curl -s -X GET \
  "${CODESPACE_URL_TC}/admin/realms/nextjs-test/clients?clientId=account" \
  -H "Authorization: Bearer $TOKEN")
CLIENT_UID=$(echo "$CLIENT_RESULT" | jq -r '.[0].id')

echo "📥 [9/9] Fetching adapter config for client UID $CLIENT_UID..."
ADAPTER_RESULT=$(curl -s -X GET \
  "${CODESPACE_URL_TC}/admin/realms/nextjs-test/vendorResources/get-installations-provider?clientId=$CLIENT_UID&providerId=keycloak-oidc-keycloak-json" \
  -H "Authorization: Bearer $TOKEN")

echo "📝 Writing adapter config into tidecloak.json..."
echo "$ADAPTER_RESULT" > tidecloak-client-nextJS/tidecloak.json

echo "✅ Setup complete! Next.js app is ready with the dynamic Tidecloak config."
