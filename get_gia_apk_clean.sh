#!/bin/bash

# Carpeta temporal para descargar y descomprimir
TMP_DIR=~/GIA_APP/apk
mkdir -p $TMP_DIR

# Usuario y repo
GITHUB_USER="Azcantonio75"
REPO_NAME="Azcantonio75-source"

# Buscar el workflow más reciente
echo "🔎 Buscando último artifact de GIA 4.0..."
LATEST_RUN=$(gh run list -R $GITHUB_USER/$REPO_NAME -L 1 --json databaseId --jq '.[0].databaseId')

if [ -z "$LATEST_RUN" ]; then
    echo "❌ No se encontró ningún workflow ejecutado."
    exit 1
fi

# Descargar artifact
echo "⬇️ Descargando artifact (APK)..."
gh run download $LATEST_RUN -R $GITHUB_USER/$REPO_NAME -D $TMP_DIR

# Descomprimir automáticamente
echo "📦 Descomprimiendo artifact..."
for zipfile in $TMP_DIR/*.zip; do
    unzip -o "$zipfile" -d $TMP_DIR
done

# Copiar la APK a Descargas
echo "📂 Moviendo APK a Descargas..."
mkdir -p ~/storage/downloads
cp $TMP_DIR/*.apk ~/storage/downloads/

echo "✅ APK lista en Descargas: ~/storage/downloads/"
