#!/bin/bash
set -e

echo "🔧 [0/13] Installing required dependencies (OpenSSL)..."
sudo apt-get update
sudo apt-get install -y libssl-dev


echo "🚀 [1/13] Cloning the Tidecloak Next.js client..."
git clone https://github.com/tide-foundation/tidecloak-client-nextJS.git

echo "📦 [2/13] Installing dependencies..."
cd tidecloak-client-nextJS
npm install
cd ..

echo "🌐 [3/13] Building Codespace URLs..."
CODESPACE_URL_NEXT="https://${CODESPACE_NAME}-3000.app.github.dev"
CODESPACE_URL_TC="https://${CODESPACE_NAME}-8080.app.github.dev"
TIDECLOAK_LOCAL_URL="http://localhost:8080"

echo "🔄 [4/13] Updating test-realm.json with Codespace URL..."
cp .devcontainer/test-realm.json tidecloak-client-nextJS/test-realm.json
sed -i "s|http://localhost:3000|${CODESPACE_URL_NEXT}|g" tidecloak-client-nextJS/test-realm.json

echo "🐳 [5/13] Pulling and starting Tidecloak container..."
docker pull docker.io/tideorg/tidecloak-dev:latest
docker run -d \
  --name tidecloak \
  -p 8080:8080 \
  -e KC_HOSTNAME=${CODESPACE_URL_TC} \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=password \
  tideorg/tidecloak-dev:latest

echo "⏳ [6/13] Waiting for Tidecloak to become ready..."
until curl -s "${TIDECLOAK_LOCAL_URL}/realms/master/.well-known/openid-configuration" > /dev/null; do
  sleep 2
  echo "⌛ Still waiting for Tidecloak..."
done

echo "🔐 [7/13] Fetching admin token..."
RESULT=$(curl -s --data "username=admin&password=password&grant_type=password&client_id=admin-cli" \
  "${TIDECLOAK_LOCAL_URL}/realms/master/protocol/openid-connect/token")
TOKEN=$(echo "$RESULT" | sed 's/.*access_token":"//g' | sed 's/".*//g')

echo "🌍 [8/13] Creating realm using Admin API..."
curl -s -X POST "${TIDECLOAK_LOCAL_URL}/admin/realms" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary @tidecloak-client-nextJS/test-realm.json

echo "🛠️ [9/13] Creating Tide IDP, licensing, and enabling IGA..."
curl -s -X POST "${TIDECLOAK_LOCAL_URL}/admin/realms/nextjs-test/vendorResources/setUpTideRealm" \
  -H "Authorization: Bearer $TOKEN" \
  -d "email=email@tide.org"

curl -s -X POST "${TIDECLOAK_LOCAL_URL}/admin/realms/nextjs-test/tideAdminResources/toggle-iga" \
  -H "Authorization: Bearer $TOKEN" \
  -d "isIGAEnabled=true"

echo "✅ [10/13] Approving and committing all client default user context..."
CLIENTREQUESTS=$(curl -s -X GET "${TIDECLOAK_LOCAL_URL}/admin/realms/nextjs-test/tide-admin/change-set/clients/requests" \
  -H "Authorization: Bearer $TOKEN")

echo "$CLIENTREQUESTS"

if ! echo "$CLIENTREQUESTS" | jq empty; then
  echo "❌ Error: The GET response is not valid JSON."
  exit 1
fi

echo "$CLIENTREQUESTS" | jq -c '.[]' | while IFS= read -r record; do
  changeSetId=$(echo "$record" | jq -r '.draftRecordId')
  changeSetType=$(echo "$record" | jq -r '.changeSetType')
  actionType=$(echo "$record" | jq -r '.actionType')

  payload=$(jq -n --arg id "$changeSetId" --arg type "$changeSetType" --arg action "$actionType" \
    '{changeSetId: $id, changeSetType: $type, actionType: $action}')

  echo "📝 Payload: $payload"

  sign_response=$(curl -s -X POST "${TIDECLOAK_LOCAL_URL}/admin/realms/nextjs-test/tide-admin/change-set/sign" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$payload")

  echo "🔏 Sign Response: $sign_response"

  commit_response=$(curl -s -X POST "${TIDECLOAK_LOCAL_URL}/admin/realms/nextjs-test/tide-admin/change-set/commit" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$payload")

  echo "✅ Commit Response: $commit_response"
done

echo "👤 [11/13] Creating test user..."
USER_REALM="nextjs-test"
response=$(curl -s -X POST "${TIDECLOAK_LOCAL_URL}/admin/realms/${USER_REALM}/users" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "attributes": {
      "locale": ""
    },
    "requiredActions": [],
    "emailVerified": false,
    "username": "testuser",
    "email": "testuser@tidecloak.com",
    "firstName": "test",
    "lastName": "user",
    "groups": [],
    "enabled": true
  }')

echo "📥 [12/13] Fetching adapter config and writing to tidecloak.json..."
CLIENT_RESULT=$(curl -s -X GET \
  "${TIDECLOAK_LOCAL_URL}/admin/realms/nextjs-test/clients?clientId=myclient" \
  -H "Authorization: Bearer $TOKEN")
CLIENT_UID=$(echo "$CLIENT_RESULT" | jq -r '.[0].id')

ADAPTER_RESULT=$(curl -s -X GET \
  "${TIDECLOAK_LOCAL_URL}/admin/realms/nextjs-test/vendorResources/get-installations-provider?clientId=$CLIENT_UID&providerId=keycloak-oidc-keycloak-json" \
  -H "Authorization: Bearer $TOKEN")

echo "$ADAPTER_RESULT" > tidecloak-client-nextJS/tidecloak.json

echo "🎉 [13/13] Setup complete! Next.js app is ready with the dynamic Tidecloak config."

echo ""
echo "✅ Setup complete. You can close this terminal or continue below."
echo ""