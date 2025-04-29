#!/usr/bin/env bash
set -euo pipefail

URL_ROOT="${URL_ROOT:-https://arquivos.receitafederal.gov.br/dados/cnpj/dados_abertos_cnpj/2025-04/}"
DEST_BUCKET="${DEST_BUCKET:?DEST_BUCKET env var required (gs://…)}"


echo "Listing remote files..."

FILELIST=$(curl -s "$URL_ROOT" | grep -Eo 'href="[^"]+\.zip"' | cut -d'"' -f2)

echo "Downloading to tmpfs and streaming to $DEST_BUCKET"
mkdir -p /tmp/cnpj
cd /tmp/cnpj

for FILE in $FILELIST; do
  OBJECT_URI="$DEST_BUCKET/$FILE"

  # ------------------------------------------------------------------
  # 1. Does the object already exist in the bucket?
  # ------------------------------------------------------------------
  if gsutil -q stat "$OBJECT_URI"; then
    echo "⏩  Skipping $FILE (already in bucket)"
    continue
  fi

  echo "▶︎ Downloading $FILE"
  aria2c -x16 -s16 -k1M "${URL_ROOT}${FILE}" -o "$FILE"

  echo "⇪ Copying $FILE to $DEST_BUCKET"
  gsutil cp "$FILE" "$DEST_BUCKET/"

  rm "$FILE"
done

echo "✅ Sync complete – only new files were downloaded."
