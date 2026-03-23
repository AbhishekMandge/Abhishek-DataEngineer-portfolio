#!/bin/bash

# Load .env variables if the file exists
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

if [ -z "$DUCKDNS_DOMAIN" ] || [ -z "$DUCKDNS_TOKEN" ]; then
  echo "Error: DUCKDNS_DOMAIN and DUCKDNS_TOKEN must be set in your .env file."
  echo "Format:"
  echo "DUCKDNS_DOMAIN=your_domain"
  echo "DUCKDNS_TOKEN=your_token"
  exit 1
fi

echo "Updating DuckDNS IP for domain: $DUCKDNS_DOMAIN..."
URL="https://duckdns.org/update/$DUCKDNS_DOMAIN/$DUCKDNS_TOKEN"

# If an IP address is explicitly provided via environment variable, append it
if [ ! -z "$DUCKDNS_IP" ]; then
  URL="$URL/$DUCKDNS_IP"
fi

# Make the request and store the response
RESPONSE=$(curl -s "$URL")

if [ "$RESPONSE" = "OK" ]; then
  echo "Successfully updated DuckDNS!"
else
  echo "Failed to update DuckDNS. Response: $RESPONSE"
  exit 1
fi
