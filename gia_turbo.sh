#!/bin/bash

# -------------------------
# GIA 4.0 Turbo Launcher
# -------------------------

# Carpeta temporal para APK
TMP_DIR=~/GIA_APP/apk
mkdir -p $TMP_DIR

# Usuario y repo
GITHUB_USER="azcantonio75-source"
REPO_NAME="GIA4.0"

# Token de GitHub desde variable de entorno
if [ -z "$GH_TOKEN" ]; then
    read -p "🔑 Ingresa tu token GH_TOKEN: " GH_TOKEN
fi
echo $GH_TOKEN | gh auth login --with-token

echo "🔎 Esperando workflow de GIA 4.0..."

# Esperar workflow completado
while true; do
    LATEST_JSON=$(gh run list -R $GITHUB_USER/$REPO_NAME -L 1 --json databaseId,status,conclusion)
    LATEST_ID=$(echo $LATEST_JSON | jq -r '.[0].databaseId')
    STATUS=$(echo $LATEST_JSON | jq -r '.[0].status')
    CONCLUSION=$(echo $LATEST_JSON | jq -r '.[0].conclusion')

    if [ -z "$LATEST_ID" ]; then
        echo "⏳ No se encontró workflow, esperando 10s..."
        sleep 10
        continue
    fi

    echo "🟢 Workflow ID: $LATEST_ID | Estado: $STATUS | Resultado: $CONCLUSION"

    if [ "$STATUS" == "completed" ]; then
        if [ "$CONCLUSION" == "success" ]; then
            break
        else
            echo "❌ Workflow falló. Revisa en GitHub Actions."
            exit 1
        fi
    fi

    sleep 10
done

echo "✅ Workflow completado, descargando artifact..."
gh run download $LATEST_ID -R $GITHUB_USER/$REPO_NAME -D $TMP_DIR

echo "📦 Descomprimiendo artifact..."
for zipfile in $TMP_DIR/*.zip; do
    unzip -o "$zipfile" -d $TMP_DIR
done

# Copiar APK a Descargas
mkdir -p ~/storage/downloads
cp $TMP_DIR/*.apk ~/storage/downloads/
echo "🎉 GIA 4.0 APK lista en Descargas: ~/storage/downloads/"
