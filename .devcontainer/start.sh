#!/bin/bash
set -e
git clone https://github.com/tide-foundation/tidecloak-client-nextJS.git
cd tidecloak-client-nextJS
npm install
npm run dev
