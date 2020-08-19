#!/usr/bin/env bash

# Note: This script runs after the ansible install, use it to make configuration
# changes which would otherwise be overwritten by ansible.
sudo su

# Create an htpasswd file, we'll use htpasswd auth for OpenShift.
htpasswd -cb /etc/origin/master/htpasswd user 123
echo "Password for 'admin' set to '123'"
htpasswd -b /etc/origin/master/htpasswd ${admin_username} ${admin_password}
kubectl create clusterrolebinding real-admin-binding --clusterrole=cluster-admin --user=${admin_username}

# Update the docker config to allow OpenShift's local insecure registry. Also
# use json-file for logging, so our Elastic monitoring stack can trace container logs
# json-file for logging
sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --insecure-registry 172.30.0.0/16 --log-driver=json-file --log-opt max-size=1M --log-opt max-file=3"' /etc/sysconfig/docker
echo "Docker configuration updated..."