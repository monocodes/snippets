#!/bin/bash

hosts="192.168.1.10 192.168.1.15 192.168.1.14 192.168.1.156 192.168.1.102 192.168.1.96"

for host in $hosts
do
  cat ~/.ssh/id_ed25519.pub | ssh -o ConnectTimeout=8 -o BatchMode=yes -o StrictHostKeyChecking=no mono@$host "cat > ~/.ssh/authorized_keys"
  ssh -o ConnectTimeout=8 -o BatchMode=yes -o StrictHostKeyChecking=no $host "cat ~/.ssh/authorized_keys"
done
