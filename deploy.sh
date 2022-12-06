#!/bin/bash

echo "begin to deploy using gcloud..."
echo $vm_name
gcloud compute instances create $vm_name \
    --network-interface=network-tier=PREMIUM,subnet=$subnetwork \
    --zone=$zone \
    --project=$project_id
