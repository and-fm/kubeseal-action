FROM alpine/curl:latest

# Install jq
RUN curl -L "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64" -o /bin/jq
RUN chmod +x /bin/jq

RUN KUBESEAL_VERSION=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/tags | jq -r '.[0].name' | cut -c 2-)

RUN curl -L "https://github.com/bitnami-labs/sealed-secrets/releases/download/v$KUBESEAL_VERSION/kubeseal-$KUBESEAL_VERSION-linux-amd64.tar.gz" -o /bin/kubeseal
RUN chmod +x /bin/kubeseal

RUN cat /bin/kubeseal

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]