#!/bin/bash

source pangu.env

gcloud compute instances create $vm_name \
    --network-interface=network-tier=PREMIUM,subnet=$subnetwork \
    --zone=$zone \
    --project=$project_id
