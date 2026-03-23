#!/bin/bash

# Carpeta temporal
TMP_DIR=~/GIA_APP/apk
mkdir -p $TMP_DIR

# Usuario y repo
GITHUB_USER="azcantonio75-source"
REPO_NAME="GIA4.0"

echo "🔎 Esperando workflow de GIA 4.0..."

# Esperar hasta que haya un workflow completado
while true; do
    LATEST=$(gh run list -R $GITHUB_USER/$REPO_NAME -L 1 --json databaseId,status --jq '.[0] | select(.status=="completed") | .databaseId')
    if [ ! -z "$LATEST" ]; then
        break
    fi
    echo "⏳ Workflow aún no terminado, reintentando en 10s..."
    sleep 10
done

echo "✅ Workflow completado, descargando artifact..."
gh run download $LATEST -R $GITHUB_USER/$REPO_NAME -D $TMP_DIR

echo "📦 Descomprimiendo artifact..."
for zipfile in $TMP_DIR/*.zip; do
    unzip -o "$zipfile" -d $TMP_DIR
done

# Copiar APK a Descargas
mkdir -p ~/storage/downloads
cp $TMP_DIR/*.apk ~/storage/downloads/
echo "🎉 GIA 4.0 APK lista en Descargas: ~/storage/downloads/"
