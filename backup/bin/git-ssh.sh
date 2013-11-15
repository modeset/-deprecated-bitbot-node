#!/bin/sh
exec ssh -i "$IDENTITY_FILE" -o "StrictHostKeyChecking no" "$@"
