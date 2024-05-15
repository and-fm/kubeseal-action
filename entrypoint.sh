#!/bin/sh -l

echo "$2" >> secret.yaml

kubeseal --cert $1 -f secret.yaml -w sealed-secret.yaml

echo 'out_yaml<<EOF' >> $GITHUB_OUTPUT
cat sealed-secret.yaml >> $GITHUB_OUTPUT
echo "EOF" >> $GITHUB_OUTPUT