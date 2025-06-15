#!/bin/bash

# Pfad zu deinem Docker Compose Projekt
PROJECT_PATH="/home/USERNAME/docker/sucky"
LOG_FILE="/var/log/docker_sucky_update.log" # Log-Datei für die Ausgabe

# Ersetze USERNAME durch deinen tatsächlichen Benutzernamen
YOUR_USERNAME="USERNAME"

# Sicherstellen, dass die Log-Datei existiert und schreibbar ist
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    chown "$YOUR_USERNAME":"$YOUR_USERNAME" "$LOG_FILE" # Besitzer ändern, falls nötig
fi

# Datum und Uhrzeit der Ausführung in die Log-Datei schreiben
echo "--- Docker Sucky Update gestartet am $(date) ---" >> "$LOG_FILE"

# In das Projektverzeichnis wechseln
cd "$PROJECT_PATH" >> "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo "Fehler: Konnte nicht in das Verzeichnis $PROJECT_PATH wechseln." >> "$LOG_FILE"
    exit 1
fi

# Docker Compose Up mit Build und Prune
# --pull all: Zieht immer die neuesten Images (empfohlen für Aktualisierungen)
# --build: Baut Images neu, falls Dockerfiles verwendet werden
# --detach: Startet die Container im Hintergrund
# --remove-orphans: Entfernt Container, die nicht mehr in der compose.yaml definiert sind
# --force-recreate: Erzwingt die Neuerstellung von Containern
echo "Führe 'docker compose pull' aus..." >> "$LOG_FILE"
docker compose pull >> "$LOG_FILE" 2>&1

echo "Führe 'docker compose up -d --remove-orphans --force-recreate --build' aus..." >> "$LOG_FILE"
docker compose up -d --remove-orphans --force-recreate --build >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Docker Sucky Container erfolgreich aktualisiert." >> "$LOG_FILE"
else
    echo "FEHLER: Docker Sucky Container konnten nicht aktualisiert werden." >> "$LOG_FILE"
fi

echo "--- Docker Sucky Update beendet am $(date) ---" >> "$LOG_FILE"
echo "" >> "$LOG_FILE" # Leerzeile für bessere Lesbarkeit
