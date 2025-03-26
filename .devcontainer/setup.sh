#!/bin/bash
set -e

echo "🚀 [1/7] Cloning the Tidecloak Next.js client..."
git clone https://github.com/tide-foundation/tidecloak-client-nextJS.git

echo "📦 [2/7] Installing dependencies..."
cd tidecloak-client-nextJS
npm install
cd ..

echo "🌐 [3/7] Getting Codespace URLs for JSON replacement and realm setup..."
CODESPACE_URL_NEXT="https://${CODESPACE_NAME}-3000.app.github.dev"
CODESPACE_URL_TC="https://${CODESPACE_NAME}-8080.app.github.dev"

echo "🔄 [4/7] Replacing localhost:3000 with $CODESPACE_URL_NEXT in .devcontainer/test-realm.json..."
sed -i "s|http://localhost:3000|${CODESPACE_URL_NEXT}|g" .devcontainer/test-realm.json

echo "📥 Copying updated test-realm.json into the cloned repo root..."
cp .devcontainer/test-realm.json tidecloak-client-nextJS/test-realm.json

echo "🐳 [5/7] Pulling and starting Docker container..."
docker pull docker.io/tideorg/tidecloak-dev:latest
docker run -d \
  -v "$(pwd)":/opt/keycloak/data/h2 \
  -v "$(pwd)/tidecloak-client-nextJS/test-realm.json":/opt/keycloak/data/import/test-realm.json \
  --name tidecloak \
  -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=password \
  tideorg/tidecloak-dev:latest

echo "🔐 Fetching admin token from Tidecloak..."
RESULT=$(curl --silent --data "username=admin&password=password&grant_type=password&client_id=admin-cli" "${CODESPACE_URL_TC}/realms/master/protocol/openid-connect/token")
TOKEN=$(echo "$RESULT" | sed 's/.*access_token":"//g' | sed 's/".*//g')

echo "📤 Posting setup to Tidecloak vendor endpoint..."
curl -X POST "${CODESPACE_URL_TC}/admin/realms/nextjs-test/vendorResources/setUpTideRealm" \
  -H "Authorization: Bearer $TOKEN" \
  -d "email=email@example.com"

echo "🛠 [6/7] Creating tidecloak.json config for Next.js app..."
cat <<EOF > tidecloak-client-nextJS/tidecloak.json
{
  "realm": "nextjs-test",
  "auth-server-url": "https://login.dauth.me",
  "ssl-required": "external",
  "resource": "myclient",
  "public-client": true,
  "confidential-port": 0,
  "jwk": {
    "keys": [
      {
        "kid": "p4Eb1ZCr-8kV5ry_UcqC85Mdve4nhw67qhJ9kBoEQmk",
        "kty": "OKP",
        "alg": "EdDSA",
        "use": "sig",
        "crv": "Ed25519",
        "x": "9JG7Y-kBbsmrHgwgi1vX0Q6ggzqwic7StV7BDFogVZo"
      }
    ]
  },
  "vendorId": "7157782403750047881996238811296685929925291662415140531663581482765538159599",
  "homeOrkUrl": "https://ork1.tideprotocol.com"
}
EOF

echo "✅ [7/7] Setup complete. Next.js app is ready to launch!"
