#!/bin/bash
set -e

# === Configuration ===
DB_PATH="/home/pi/spoolman/data/spoolman.db"
REPO_DIR="/home/pi/.local/share/spoolman"
TARGET_DB="$REPO_DIR/spoolman.db"

echo "=== BACKUP START ==="
echo "Time: $(date)"

# Copy DB
cp -f "$DB_PATH" "$TARGET_DB"

cd "$REPO_DIR" || exit

/usr/bin/git add spoolman.db

if ! /usr/bin/git diff --cached --quiet; then
    /usr/bin/git commit -m "Auto backup Spoolman DB $(date '+%Y-%m-%d %H:%M:%S')"
    /usr/bin/git push origin main
    echo "Backup committed and pushed."
else
    echo "No changes to commit."
fi

echo "=== BACKUP END ==="
