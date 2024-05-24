FROM alpine/curl:latest

# Install jq
RUN curl -L "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64" -o /bin/jq
RUN chmod +x /bin/jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]