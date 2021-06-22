#!/bin/bash
servername=$1

statusCode=$(curl --write-out '%{http_code}' --silent --output /dev/null $servername)

if [[ $statusCode -ge 200 && $statusCode -le 299 ]]; then
  exit 0
else
  exit 1
fi
