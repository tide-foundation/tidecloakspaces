#!/bin/bash
set -e

echo "🔄 Cloning the Tidecloak Next.js client..."
git clone https://github.com/tide-foundation/tidecloak-client-nextJS.git

cd tidecloak-client-nextJS
echo "📦 Installing dependencies..."
npm install

echo "🛠 Creating tidecloak.json configuration..."
cat <<EOF > tidecloak.json
... [your JSON content here] ...
EOF

cd ..
echo "🐳 Pulling and running Tidecloak Docker image..."
docker pull docker.io/tideorg/tidecloak-dev:latest
docker run -d \
  -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=password \
  tideorg/tidecloak-dev:latest

echo "✅ Docker running. Next.js will start with postStartCommand"
