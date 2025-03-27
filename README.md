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

| Step       | Description                                                                                 |
|------------|---------------------------------------------------------------------------------------------|
| 🚀 **[1/9]** | Cloning the Tidecloak Next.js client repo                                                  |
| 📦 **[2/9]** | Installing project dependencies for the frontend                                           |
| 🌐 **[3/9]** | Building the dynamic Codespace URL for use in redirect and origin settings                 |
| 🔄 **[4/9]** | Replacing `localhost:3000` with your live Codespace URL in the `test-realm.json` config    |
| 🐳 **[5/9]** | Pulling and launching the Tidecloak Docker container on port `8080`                        |
| ⏳ **[6/9]** | Waiting for Tidecloak to be fully ready                                                     |
| 🔐 **[7/9]** | Fetching an admin token using the master realm                                             |
| 🌍 **[8/9]** | Creating the `nextjs-test` realm via the Tidecloak admin API from `test-realm.json`        |
| 📥 **[9/9]** | Fetching the dynamic OIDC adapter config and writing it to `tidecloak.json`                |

✅ Once all steps complete, your Next.js app is fully configured and integrated with the running Tidecloak instance.


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