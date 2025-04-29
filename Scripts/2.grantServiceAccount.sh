PROJECT=$(gcloud config get-value project)
export CNPJ_BUCKET=gs://cnpj-raw-$(gcloud config get-value project)-us

gsutil iam ch \
  "serviceAccount:$PROJECT-compute@developer.gserviceaccount.com:roles/storage.objectAdmin" \
  $CNPJ_BUCKET
