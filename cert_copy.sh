#!/bin/bash

# Define variables
DOMAIN="joranslingerland.com"
LE_PATH="/etc/letsencrypt/live/$DOMAIN"
CERT_DEST="/data/coolify/proxy/certs"

# Files to work with
FULLCHAIN="$LE_PATH/fullchain.pem"
PRIVKEY="$LE_PATH/privkey.pem"
CERT_FILE="domain.cert"
KEY_FILE="domain.key"

# Step 1: Convert certificate and key
echo "Copy certificate and key to the server"
mkdir -p "$CERT_DEST"
cp "$FULLCHAIN" "$CERT_DEST/$CERT_FILE"
cp "$PRIVKEY" "$CERT_DEST/$KEY_FILE"

echo "Certificate and key copied successfully."

# Step 2: Remove old certificates
echo "Removing old acme.json file..."
if [ -f "$ACME_FILE" ]; then
    rm "$ACME_FILE"
    echo "Old acme.json file removed."
else
    echo "No acme.json file found, skipping removal."
fi

# Step 3: Restart Coolify proxy
echo "Restarting Coolify proxy..."
cd "$DOCKER_COMPOSE_PATH" && docker compose restart

echo "Process completed! Coolify proxy has been restarted."
