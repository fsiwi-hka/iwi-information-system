#!/bin/bash

APP_DIR="/home/fachschaft-iwi/Dokumente/information-system/"
APP_NAME="main.py"

cd "$APP_DIR" || { echo "Failed to change directory to $APP_DIR"; exit 1; }
    /usr/bin/env python "$APP_NAME" &
echo "Started $APP_NAME"

