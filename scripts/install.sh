#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
set -euo pipefail
[[ $EUID -ne 0 ]] || { echo 'Run as your normal desktop user, without sudo.' >&2; exit 1; }
command -v kpackagetool6 >/dev/null
base=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
id=com.github.mkeays501.macoscontrolcentre
data=${XDG_DATA_HOME:-$HOME/.local/share}
state=${XDG_STATE_HOME:-$HOME/.local/state}
config=${XDG_CONFIG_HOME:-$HOME/.config}
dest="$data/plasma/plasmoids/$id"
mkdir -p -- "$state/macos-controlcentre-backups"
backup=$(mktemp -d "$state/macos-controlcentre-backups/backup-XXXXXXXX")
printf '%s\n' "$id" > "$backup/plugin-id"
if [[ -d $dest ]]; then
    cp -a -- "$dest" "$backup/package"
    mode=-u
else
    mode=-i
fi
# A reference copy only: never replace all panel settings in a running session.
if [[ -f $config/plasma-org.kde.plasma.desktop-appletsrc ]]; then
    cp -a -- "$config/plasma-org.kde.plasma.desktop-appletsrc" "$backup/desktop-appletsrc.reference"
fi
printf 'Backup: %s\n' "$backup"
if ! kpackagetool6 -t Plasma/Applet "$mode" "$base/package"; then
    printf 'Installation failed. Keep the backup above; see INSTALL.md.\n' >&2
    exit 1
fi
printf 'Installed. Log out and back in to reload Plasma.\nRollback: bash %q %q\n' "$base/scripts/rollback.sh" "$backup"
