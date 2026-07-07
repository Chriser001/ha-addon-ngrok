FROM ngrok/ngrok:3-alpine

USER root

ENTRYPOINT ["/bin/sh", "-c", "\
OPTIONS_FILE=/data/options.json && \
NGROK_CONFIG_PATH=/tmp/ngrok.yml && \
AUTH_TOKEN=$(sed -n 's/.*\"auth_token\"[^\"]*\"\\([^\"]*\\)\".*/\\1/p' \"$OPTIONS_FILE\" | tr -d ' \\t\\n\\r') && \
UPSTREAM_URL=$(sed -n 's/.*\"upstream_url\"[^\"]*\"\\([^\"]*\\)\".*/\\1/p' \"$OPTIONS_FILE\" | tr -d ' \\t\\n\\r') && \
URL_PARAM=$(sed -n 's/.*\"url_param\"[^\"]*\"\\([^\"]*\\)\".*/\\1/p' \"$OPTIONS_FILE\" | tr -d ' \\t\\n\\r') && \
cat > \"$NGROK_CONFIG_PATH\" <<EOF\n\
version: 2\n\
authtoken: ${AUTH_TOKEN}\n\
EOF\n\
if [ -n \"$URL_PARAM\" ]; then\n  exec ngrok http \"$UPSTREAM_URL\" --url \"$URL_PARAM\" --pooling-enabled --config \"$NGROK_CONFIG_PATH\"\nelse\n  exec ngrok http \"$UPSTREAM_URL\" --pooling-enabled --config \"$NGROK_CONFIG_PATH\"\nfi \
"]
