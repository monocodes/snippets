#!/bin/bash

SUBNET='192.168.1.'
HOSTS="$SUBNET"105" $SUBNET"137" $SUBNET"135""
PUBKEY='ansible-key-secret.pub'
USER='ansible'

for HOST in $HOSTS
do
  cat $PUBKEY | ssh -o ConnectTimeout=8 -o BatchMode=yes -o StrictHostKeyChecking=no $USER@$HOST \
  "cat > ~/.ssh/authorized_keys"
  ssh -o ConnectTimeout=8 -o BatchMode=yes -o StrictHostKeyChecking=no $USER@$HOST "cat ~/.ssh/authorized_keys"
done
