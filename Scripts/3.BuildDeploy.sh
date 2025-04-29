# 1. Build the container
gcloud builds submit --tag gcr.io/$(gcloud config get-value project)/cnpj-downloader .

# 2. Create the job (one-off)
export CNPJ_BUCKET=gs://cnpj-raw-$(gcloud config get-value project)-us

gcloud run jobs create cnpj-download-2025-04 --image gcr.io/$(gcloud config get-value project)/cnpj-downloader --region us-central1 --memory 4Gi --cpu 4 --task-timeout 10m5s --set-env-vars "DEST_BUCKET=$CNPJ_BUCKET"

gcloud run jobs update cnpj-download-2025-04 --region southamerica-east1 --memory 4Gi --cpu 4 --task-timeout 10m5s



# 3. Run it whenever you need
gcloud run jobs execute cnpj-download-2025-04 --region us-central1


