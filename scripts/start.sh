#!/bin/bash

# Basisverzeichnis der Anwendung
BASE_DIR="/home/appuser/Apps/iwi-information-system"
APP_DIR="$BASE_DIR/app"
APP_NAME="main.py"
REQ_FILE="$BASE_DIR/requirements.txt"
VENV_DIR="$BASE_DIR/venv"
LOGFILE="$BASE_DIR/start.log"

# Logging aktivieren (optional)
exec >> "$LOGFILE" 2>&1
echo "[$(date)] Starting application..."

cd "$APP_DIR" || { echo "[$(date)] Failed to change directory to $APP_DIR"; exit 1; }

# Prüfe, ob virtuelle Umgebung existiert, wenn nicht -> erstellen
if [ ! -d "$VENV_DIR" ]; then
    echo "[$(date)] Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Aktiviere virtuelle Umgebung
source "$VENV_DIR/bin/activate"

# Installiere Abhängigkeiten
if [ -f "$REQ_FILE" ]; then
    echo "[$(date)] Installing requirements..."
    pip install --upgrade pip
    pip install -r "$REQ_FILE"
else
    echo "[$(date)] No requirements.txt found at $REQ_FILE"
fi

# Prüfen, ob das Programm bereits läuft
if pgrep -f "$APP_NAME" > /dev/null; then
    echo "[$(date)] $APP_NAME is already running."
    exit 0
fi

# Starte Anwendung
echo "[$(date)] Waiting for desktop to initialize..."
sleep 10

echo "[$(date)] Launching $APP_NAME..."
/usr/bin/env python "$APP_NAME" &

echo "[$(date)] Started $APP_NAME"
