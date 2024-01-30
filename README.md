## gcp cloudbuild
```bash
export REGION=europe-west2
gcloud builds submit --region=${REGION} --config=cloudbuild.yaml \
  --substitutions=_LOCATION="${REGION}",_REPOSITORY="cloudrun",_IMAGE="nextjs14" .
```

## test dev/cloudrun/apigee/verify/inbound/test.csv.gz pubsub trigger
```bash
curl -X POST -d "@request.json" http://localhost:8080/api/pubsub/verify
```

## create subscription
```
export SERVICE_URL=https://nextjs14-u25a4tsuzq-nw.a.run.app/api/pubsub/verify
gcloud beta pubsub subscriptions create conv-sub --topic dev-integration-cloudrun-verify \
  --push-endpoint=$SERVICE_URL \
  --push-auth-service-account=dev-apigee-bucket@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --ack-deadline=120
```
