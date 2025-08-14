#!/bin/bash -x

dnf install iptables-services -y

# attach the ENI
aws ec2 attach-network-interface \
  --region "$(/usr/bin/ec2-metadata -z  | sed 's/placement: \(.*\).$/\1/')" \
  --instance-id "$(/usr/bin/ec2-metadata -i | cut -d' ' -f2)" \
  --device-index 1 \
  --network-interface-id "${eni_id}"

# start SNAT
systemctl enable snat
systemctl start snat
