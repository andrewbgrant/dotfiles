#!/bin/bash

function typescript-init() {
    if [ -z "$1" ]; then
        echo "❌ Please provide a project name."
        return 1
    fi

    mkdir "$1" && cd "$1" || return

    echo "📦 Initializing npm project..."
    npm init -y

    echo "📥 Installing TypeScript and types..."
    npm install -dev typescript @types/node eslint @eslint/js typescript-eslint

    echo "🛠 Initializing TypeScript config..."
    npx tsc --init

    echo "📝 Writing tsconfig.json..."
    cat >tsconfig.json <<EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  }
}
EOF

    echo "📁 Creating source folder and index.ts..."
    mkdir src
    echo "console.log('Hello, TypeScript');" >src/index.ts

    echo "⚙️  Setting up ESLint..."
    cat >eslint.config.mjs <<EOF
// @ts-check

import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  eslint.configs.recommended,
  tseslint.configs.recommended,
);
EOF

    echo "🧾 Adding build/start scripts to package.json..."
    if command -v json &>/dev/null; then
        npx json -I -f package.json -e 'this.scripts={build:"tsc",start:"node dist/index.js"}'
    else
        echo "⚠️ 'json' CLI not found; skipping scripts injection. Add manually:"
        echo '  "scripts": { "build": "tsc", "start": "node dist/index.js" }'
    fi

    echo "✅ Node + TypeScript project initialized in '$1'"
}
