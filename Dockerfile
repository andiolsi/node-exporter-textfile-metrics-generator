FROM alpine:latest

WORKDIR /node-exporter-textfile-metrics-generator

COPY scripts/* ./

ENTRYPOINT [ "/node-exporter-textfile-metrics-generator/entrypoint.sh" ]
RUN apk add --update-cache bash openssl ca-certificates curl jq
