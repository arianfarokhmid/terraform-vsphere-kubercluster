#!/bin/bash
# Get worker and control plane IPs from Terraform outputs
WORKER_IPS=$(terraform output -json worker_ips | jq -r '.[]')
CONTROL_PLANE_IPS=$(terraform output -json control_plane_ips | jq -r '.[]')

# Write the IPs to hosts.ini file
cat <<EOF > hosts.ini
[control-plane]
EOF

for ip in $CONTROL_PLANE_IPS; do
  echo "$ip" >> hosts.ini
done

cat <<EOF >> hosts.ini

[worker]
EOF

for ip in $WORKER_IPS; do
  echo "$ip" >> hosts.ini
done
