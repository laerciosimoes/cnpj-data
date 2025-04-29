gcloud services enable run.googleapis.com \
                       artifactregistry.googleapis.com \
                       cloudbuild.googleapis.com

# Create (or choose) a bucket – replace with your name & region
export CNPJ_BUCKET=gs://cnpj-raw-$(gcloud config get-value project)-us
gsutil mb -l us-central1 $CNPJ_BUCKET