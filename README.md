## gcp cloudbuild
```bash
export REGION=europe-west2
gcloud builds submit --region=${REGION} --config=cloudbuild.yaml \
  --substitutions=_LOCATION="${REGION}",_REPOSITORY="nextjs",_IMAGE="nextjs14" .
```
