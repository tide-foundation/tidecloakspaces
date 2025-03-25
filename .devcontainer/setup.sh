#!/bin/bash
set -e

echo "🔄 Cloning the Tidecloak Next.js client..."
git clone https://github.com/tide-foundation/tidecloak-client-nextJS.git

cd tidecloak-client-nextJS
echo "📦 Installing dependencies..."
npm install

echo "🛠 Creating tidecloak.json configuration..."
cat <<EOF > tidecloak.json
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

echo "🚀 Starting Next.js dev server..."
npm run dev &

echo "🐳 Pulling and running Tidecloak Docker image..."
docker pull docker.io/tideorg/tidecloak-dev:latest

docker run -d \
  -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=password \
  tideorg/tidecloak-dev:latest

echo "🌐 Docker service running at: https://${CODESPACE_NAME}-8080.app.github.dev"
