#!/bin/bash
set -e

# === Configuration ===
DB_PATH="/home/pi/spoolman/data/spoolman.db"

# ukládáme do stejného repo jako config
REPO_DIR="/home/pi/printer_data/config"
TARGET_DB="$REPO_DIR/spoolman-backup/spoolman.db"

echo "=== BACKUP START ==="
echo "Time: $(date)"

# vytvoř složku pokud neexistuje
mkdir -p "$REPO_DIR/spoolman-backup"

# kontrola jestli DB existuje
if [ ! -f "$DB_PATH" ]; then
    echo "ERROR: Spoolman DB not found!"
    exit 1
fi

# kopie DB
cp -f "$DB_PATH" "$TARGET_DB"

cd "$REPO_DIR"

# git add jen soubor
/usr/bin/git add spoolman-backup/spoolman.db

if ! /usr/bin/git diff --cached --quiet; then
    /usr/bin/git commit -m "Auto backup Spoolman DB $(date '+%Y-%m-%d %H:%M:%S')"
    /usr/bin/git push origin main
    echo "Backup committed and pushed."
else
    echo "No changes to commit."
fi

echo "=== BACKUP END ==="
