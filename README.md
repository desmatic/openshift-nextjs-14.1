## gcp cloudbuild
```bash
export REGION=europe-west2 
gcloud builds submit --region=${REGION} --config=cloudbuild.yaml \
  --gcs-source-staging-dir="gs://${GOOGLE_CLOUD_PROJECT}_cloudbuild/source" \
  --substitutions=_LOCATION="${REGION}",_REPOSITORY="nextjs",_IMAGE="nextjs14" .
```
