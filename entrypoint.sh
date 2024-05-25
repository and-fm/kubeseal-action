#!/bin/sh -l

# Install kubeseal
KUBESEAL_VERSION=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/tags | jq -r '.[0].name' | cut -c 2-)

# Check if the version was fetched successfully
if [ -z "$KUBESEAL_VERSION" ]; then
    echo "Failed to fetch the latest KUBESEAL_VERSION"
    exit 1
fi

curl -L "https://github.com/bitnami-labs/sealed-secrets/releases/download/v$KUBESEAL_VERSION/kubeseal-$KUBESEAL_VERSION-linux-amd64.tar.gz" -o /bin/kubeseal
chmod +x /bin/kubeseal

echo "$(cat /bin/kubeseal)"

echo "$2" >> secret.yaml

kubeseal --cert $1 -f secret.yaml -w sealed-secret.yaml

echo 'out_yaml<<EOF' >> $GITHUB_OUTPUT
cat sealed-secret.yaml >> $GITHUB_OUTPUT
echo "EOF" >> $GITHUB_OUTPUT