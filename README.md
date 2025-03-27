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

Once your Codespace launches, the terminal will show progress as the environment configures itself automatically:

| Step        | Description                                                                                      |
|-------------|--------------------------------------------------------------------------------------------------|
| 🚀 **[1/10]** | Cloning the Tidecloak Next.js client repo                                                       |
| 📦 **[2/10]** | Installing project dependencies for the frontend                                                |
| 🌐 **[3/10]** | Building the dynamic Codespace URL for redirect and CORS configuration                          |
| 🔄 **[4/10]** | Replacing `localhost:3000` with your live Codespace URL in `test-realm.json`                    |
| 🐳 **[5/10]** | Pulling and launching the Tidecloak Docker container on port `8080`                             |
| ⏳ **[6/10]** | Waiting for Tidecloak to be fully ready (via health check)                                      |
| 🔐 **[7/10]** | Fetching the initial admin token via the master realm                                           |
| 🌍 **[8/10]** | Importing the `nextjs-test` realm dynamically via the Tidecloak Admin API                       |
| 📤 **[9/10]** | Triggering Tidecloak’s `setUpTideRealm` vendor endpoint (email provisioning or setup task)      |
| 📥 **[10/10]** | Fetching the OIDC adapter config for the `account` client and writing it to `tidecloak.json`   |

✅ After this process completes, your frontend and backend services are fully configured and ready to use.



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