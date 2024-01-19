## openshift nextjs 14.1

Note the required next.config.mjs configuration
https://nextjs.org/docs/pages/api-reference/next-config-js/output#automatically-copying-traced-files

## gcp cloudbuild
```bash
gcloud builds submit --config=cloudbuild.yaml \
  --substitutions=_LOCATION="us-east1",_REPOSITORY="my-repo",_IMAGE="nextjs14" .
```
