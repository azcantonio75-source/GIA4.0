#!/bin/bash

# --- Configuración de usuario, correo y token ---
GITHUB_USER="Azcantonio75"
GITHUB_EMAIL="Azcantonio75@gmail.com"
GITHUB_TOKEN=""
REPO_NAME="Azcantonio75-source"
REPO_URL="https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git"

# --- Entrar a la carpeta del proyecto ---
cd ~/GIA_APP || { echo "No existe la carpeta GIA_APP"; exit 1; }

# --- Crear carpetas para GitHub Actions ---
mkdir -p .github/workflows

# --- Crear buildozer.spec ---
cat > buildozer.spec << EOL
[app]
title = GIA 4.0
package.name = gia4
package.domain = org.gio
source.dir = .
source.include_exts = py,png,jpg,kv,txt
version = 0.1
requirements = python3,kivy,cryptography
orientation = portrait
android.permissions = INTERNET

[buildozer]
log_level = 2
warn_on_root = 0
EOL

# --- Crear workflow de GitHub Actions ---
cat > .github/workflows/build-apk.yml << EOL
name: Build GIA APK

on:
  push:
    branches:
      - main

jobs:
  build-apk:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Install dependencies
      run: |
        sudo apt update
        sudo apt install -y python3 python3-pip git openjdk-17-jdk unzip clang make pkg-config zlib1g-dev
        pip3 install --upgrade pip setuptools wheel cython
        pip3 install kivy buildozer

    - name: Build APK
      run: |
        buildozer android debug

    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: GIA-APK
        path: bin/*.apk
EOL

# --- Configurar Git ---
git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_EMAIL"

# --- Inicializar repositorio y push ---
git init
git branch -M main
git add .
git commit -m "GIA 4.0 inicial - listo para cloud build"
git remote remove origin 2>/dev/null
git remote add origin $REPO_URL
git push -u origin main

echo "¡Todo listo, Gio! Tu proyecto está en GitHub ($REPO_NAME) y la nube compilará la APK automáticamente."

