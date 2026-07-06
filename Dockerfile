FROM ngrok/ngrok:3-alpine

COPY run /usr/local/bin/run

ENTRYPOINT ["/usr/local/bin/run"]
