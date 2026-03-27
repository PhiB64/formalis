#!/bin/bash
# Script de renouvellement automatique du certificat formation.local

LOG_FILE="/var/log/certbot-renew.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] Début du renouvellement..." >> "$LOG_FILE"
sudo certbot renew >> "$LOG_FILE" 2>&1
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "[$DATE] Renouvellement terminé avec succès." >> "$LOG_FILE"
else
  echo "[$DATE] Erreur lors du renouvellement (code $RESULT)." >> "$LOG_FILE"
fi
