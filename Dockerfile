FROM ngrok/ngrok:3-alpine

ENTRYPOINT ["/bin/sh", "-c", "\
OPTIONS_FILE=/data/options.json && \
NGROK_CONFIG_PATH=/data/ngrok.yml && \
AUTH_TOKEN=$(sed -n 's/.*\"auth_token\"[^\"]*\"\\([^\"]*\\)\".*/\\1/p' \"$OPTIONS_FILE\" | tr -d ' \\t\\n\\r') && \
REGION=$(sed -n 's/.*\"region\"[^\"]*\"\\([^\"]*\\)\".*/\\1/p' \"$OPTIONS_FILE\" | tr -d ' \\t\\n\\r') && \
LOCAL_PORT=$(sed -n 's/.*\"local_port\"[^\"]*:\\([^,]*\\).*/\\1/p' \"$OPTIONS_FILE\" | tr -d ' \\t\\n\\r') && \
URL_PARAM=$(sed -n 's/.*\"url_param\"[^\"]*\"\\([^\"]*\\)\".*/\\1/p' \"$OPTIONS_FILE\" | tr -d ' \\t\\n\\r') && \
cat > \"$NGROK_CONFIG_PATH\" <<EOF\n\
version: 2\n\
authtoken: ${AUTH_TOKEN}\n\
EOF\n\
exec ngrok http \"$LOCAL_PORT\" --url \"$URL_PARAM\" --region \"$REGION\" --config \"$NGROK_CONFIG_PATH\" \
"]
