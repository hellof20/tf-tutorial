#!/bin/bash

echo "begin to destroy..."
gcloud compute instances delete $vm_name \
    --zone=$zone \
    --project=$project_id \
    --quiet
