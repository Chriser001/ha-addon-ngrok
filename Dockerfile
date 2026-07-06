FROM ngrok/ngrok:3-alpine

RUN adduser -D appuser

USER appuser

ENTRYPOINT ["/bin/sh", "-c", "\
OPTIONS_FILE=/data/options.json && \
NGROK_CONFIG_PATH=/data/ngrok.yml && \
AUTH_TOKEN=$(jq -r '.auth_token' \"$OPTIONS_FILE\") && \
REGION=$(jq -r '.region' \"$OPTIONS_FILE\") && \
LOCAL_PORT=$(jq -r '.local_port' \"$OPTIONS_FILE\") && \
URL_PARAM=$(jq -r '.url_param' \"$OPTIONS_FILE\") && \
cat > \"$NGROK_CONFIG_PATH\" <<EOF\n\
version: 2\n\
authtoken: ${AUTH_TOKEN}\n\
EOF\n\
exec ngrok http \"$LOCAL_PORT\" --url \"$URL_PARAM\" --region \"$REGION\" --config \"$NGROK_CONFIG_PATH\" \
"]
