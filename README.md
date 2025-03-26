# 🚀 Tidecloak DevRel Demo

Try the Tidecloak SDK and service instantly with **GitHub Codespaces** — no setup required!

---

## ✅ **Launch the Environment**
Click the button below to **fork**:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/tide-foundation/tidespaces/generate)

## 🚀 After Forking: Launch the Codespace
✅ Now that you've forked the repo, launch your Codespace:

1. Go to **Code → Codespaces**
2. Select **"Create codespace in main"** on the `main` branch

---

## ▶️ **What Happens Automatically**
Once the Codespace launches, it will:
- Clone the Tidecloak Next.js client app
- Install dependencies
- Create the `tidecloak.json` config
- Pull and run the **Docker service** (`tideorg/tidecloak-dev:latest`) with environment variables
- Start the Next.js app on port **3000**

✅ **Ports auto-forward** — no manual setup needed!

## 🛠 **Automated Setup Progress**
Once your Codespace starts, the terminal will show progress:

| Step       | Description                                                                                 |
|----------- |---------------------------------------------------------------------------------------------|
| 🚀 **[1/9]** | Cloning the Tidecloak Next.js client repo                                                   |
| 📦 **[2/9]** | Installing Next.js project dependencies                                                      |
| 🌐 **[3/9]** | Generating dynamic Codespace URLs for external access                                        |
| 🔄 **[4/9]** | Replacing `localhost:3000` with your Codespace URL in `test-realm.json`                      |
| 📥 **[4/9a]** | Copying updated `test-realm.json` into the Next.js repo root                                  |
| 🐳 **[5/9]** | Pulling and running the Tidecloak Docker container                                           |
| 🔐 **[6/9]** | Fetching the admin token from the running Docker container                                   |
| 📤 **[7/9]** | Calling Tidecloak vendor API to set up initial resources                                      |
| 🔎 **[8/9]** | Retrieving the internal Client UID for the `account` client                                   |
| 📥 **[9/9]** | Fetching the Keycloak adapter config dynamically and writing it to `tidecloak.json`          |

✅ Once setup completes, your Next.js app and Docker service are ready and running.
✅ `tidecloak.json` contains the dynamic configuration fetched from the Tidecloak service.

---

## 🌐 **Access Your Running Services**
| Service            | Description                      | Example URL (Codespace)                                         |
|--------------------|----------------------------------|-----------------------------------------------------------------|
| **Next.js App**    | SDK frontend demo                | `https://${CODESPACE_NAME}-3000.app.github.dev`                 |
| **Docker Service** | Tidecloak backend service        | `https://${CODESPACE_NAME}-8080.app.github.dev`                 |

✅ Preview opens automatically or check the **Ports tab** in Codespaces.

---

## 📜 **Docker Service Info**
The Docker container runs automatically:
```bash
docker run -d \
  -v "$(pwd)":/opt/keycloak/data/h2 \
  -v "$(pwd)/tidecloak-client-nextJS/test-realm.json":/opt/keycloak/data/import/test-realm.json \
  --name tidecloak \
  -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=password \
  tideorg/tidecloak-dev:latest