# TideCloak developer demo 🚀

Launch a demo app secured by the TideCloak SDK instantly with **GitHub Codespaces** — no setup required!

---

## **1. Fork the repo** ✅

Click the button below to **fork** this repo (C'mon, I said "fork!"):

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/tide-foundation/tidespaces/generate)

## 2. Launch the project in Codespaces 🚀

✅ Now that you've forked the repo, launch the project in your Codespace to spin up a fully working Tide.js demo app secured by TideCloak - A bare bones app showing off TideCloak's core features, to remove your worry of breaches:

1. Go to **Code → Codespaces**
2. Select **"Create codespace on main"** on the `main` branch

![How to create codespace](image/README/tidecloak_howto_createcodespace.gif)

**NOTE: This automated set-up can take around 7 mins to spin up. In the meantime:**
- Grab a coffee
- Star this project, or
- Read about the latest breach headlines, that won't bother you when you're TideCloak'ed

## **3. Have a play with the demo app** ▶️
Your Next.js frontend secured by Tidecloak is now ready for testing. A few things to note:

**a) Here's what you'll see**

The Preview opens automatically, otherwise check the **Ports tab** in Codespaces for the **Forwarded addess** in the format of _https://${CODESPACE_NAME}-3000.app.github.dev_.

**b) First time use warning**
When you click **Login** for the first time, you'll see the below Github warning. Just press **Continue** to move on.

![1743562446996](image/README/1743562446996.png)

**4. Accessing the TideCloak backend**
------------------------------------------------

**IMPORTANT: Make port 8080 public** to access the Tidecloak Admin UI.

Go to the Ports tab in Codespaces, find port 8080, and right-click → 'Change port visibility' → 'Public'

![how to makepublic](image/README/tidecloak_howto_makepublic.gif)

Then in the **Ports tab** click on the **Forwarded addess** in the format of _https://${CODESPACE_NAME}-8080.app.github.dev_. The default administrator credentials are admin / password.
