#! /bin/sh

set -a 
chmod +x ../vars.sh
source ../vars.sh
set +a

echo TF_VAR_bucket_name $TF_VAR_bucket_name
echo TF_VAR_project $TF_VAR_project
echo TF_VAR_region $TF_VAR_region
echo TF_VAR_cluster_name $TF_VAR_cluster_name
echo SENTRY_TAG $SENTRY_TAG
echo SECRET $SECRET

services=(
 containerregistry.googleapis.com
 container.googleapis.com
)

for service in "${services[@]}"; do
  echo "enabling service: ${service}"
  gcloud services enable "${service}"
done

docker-compose up -d postgres
docker-compose up -d redis
docker-compose run sentry sentry upgrade

docker-compose up -d

# Tagging docker images
docker tag postgres:9.6.1 gcr.io/$GOOGLE_CLOUD_PROJECT/postgres:latest
docker tag redis:3.0.7 gcr.io/$GOOGLE_CLOUD_PROJECT/redis:latest
docker tag sentry:8.10.0 gcr.io/$GOOGLE_CLOUD_PROJECT/sentry:latest

# Pushing Docker Images to Container Registry
docker push gcr.io/$GOOGLE_CLOUD_PROJECT/postgres:latest
docker push gcr.io/$GOOGLE_CLOUD_PROJECT/redis:latest
docker push gcr.io/$GOOGLE_CLOUD_PROJECT/sentry:latest

# Terraform commands to execute GKE module creation
terraform init
terraform apply --auto-approve


# Sentry Deployment
sed -i "s/PROJECT_ID/$TF_VAR_project/g" ../manifest/deployment.yaml

gcloud container clusters get-credentials $TF_VAR_cluster_name --region us-central1 --project $GOOGLE_CLOUD_PROJECT

kubectl apply -f ../manifest/deployment.yaml
