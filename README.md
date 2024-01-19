## gcp cloudbuild
```bash
gcloud builds submit --config=cloudbuild.yaml \
  --substitutions=_LOCATION="us-east1",_REPOSITORY="my-repo",_IMAGE="nextjs14" .
```
