export SENTRY_TAG="8.10.0"
# Run docker run --rm sentry:8.10.0 config generate-secret-key and add the secret
export SECRET="j44@64jw0oi_smeool!(r%6)c%5bb1m5==j^-n1#hi4f-v2i53"
export TF_VAR_project=$(gcloud config get-value project)
export TF_VAR_region="us-central1"
export TF_VAR_cluster_name="sentry-cluster"