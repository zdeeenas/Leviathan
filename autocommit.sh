#!/bin/bash

# --- Paths ---
config_folder=~/printer_data/config
klipper_folder=~/klipper
moonraker_folder=~/moonraker
mainsail_folder=~/mainsail
branch=main
db_file=~/printer_data/database/moonraker-sql.db

# --- Grab versions ---
grab_version(){
  if [ -d "$klipper_folder" ]; then
    klipper_commit=$(git -C $klipper_folder describe --always --tags --long)
    m1="Klipper version: $klipper_commit"
  fi
  if [ -d "$moonraker_folder" ]; then
    moonraker_commit=$(git -C $moonraker_folder describe --always --tags --long)
    m2="Moonraker version: $moonraker_commit"
  fi
  if [ -d "$mainsail_folder" ]; then
    mainsail_ver=$(head -n 1 $mainsail_folder/.version)
    m3="Mainsail version: $mainsail_ver"
  fi
}

# --- Copy SQLite DB ---
if [ -f "$db_file" ]; then
  echo "sqlite based history database found! Copying..."
  cp "$db_file" "$config_folder/"
fi

# --- Push to GitHub ---
cd "$config_folder" || exit 1
git pull origin "$branch" --no-rebase
git add .

if ! git diff --cached --quiet; then
  current_date=$(date '+%Y-%m-%d %H:%M:%S')
  grab_version
  git commit -m "Autocommit from $current_date" -m "$m1" -m "$m2" -m "$m3"
  git push origin "$branch" &
else
  echo "No changes to commit."
fi

# --- Cleanup ---
if [ -f "$config_folder/moonraker-sql.db" ]; then
  rm "$config_folder/moonraker-sql.db"
fi

echo "Backup finished."
