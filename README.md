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

---

## 🌐 **Access Your Running Services**
| Service            | Description                      | Example URL (Codespace)                                         |
|--------------------|----------------------------------|-----------------------------------------------------------------|
| **Next.js App**    | SDK frontend demo                | `https://${CODESPACE_NAME}-3000.app.github.dev`                 |
| **Docker Service** | Tidecloak Docker backend service | `https://${CODESPACE_NAME}-8080.app.github.dev`                 |

✅ Preview automatically opens inside Codespaces.  
✅ You can also view ports from the **"Ports" tab**.

---

## 📜 **Docker Service Info**
The Docker container runs automatically:
```bash
docker run -d -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=password \
  tideorg/tidecloak-dev:latest
