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


echo "Process completed!"
