#!/bin/bash
source pangu.env
gcloud compute instances delete $vm_name \
    --zone=$zone \
    --project=$project_id \
    --quiet
