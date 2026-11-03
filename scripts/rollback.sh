#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
set -euo pipefail
[[ $EUID -ne 0 ]] || { echo 'Run without sudo.' >&2; exit 1; }
[[ $# -eq 1 ]] || { echo 'Usage: bash scripts/rollback.sh /path/to/backup' >&2; exit 1; }
id=com.github.mkeays501.macoscontrolcentre
backup=$1
[[ -f $backup/plugin-id && $(cat -- "$backup/plugin-id") == "$id" ]] || { echo 'Not a recognized backup.' >&2; exit 1; }
if [[ -d $backup/package ]]; then
    # Keep the current files too, in case restoring the older package fails.
    data=${XDG_DATA_HOME:-$HOME/.local/share}
    current="$data/plasma/plasmoids/$id"
    if [[ -d $current ]]; then
        recovery=$(mktemp -d "$backup/pre-rollback-XXXXXXXX")
        cp -a -- "$current" "$recovery/package"
        printf 'Current package also saved to %s\n' "$recovery/package"
    fi
fi
kpackagetool6 -t Plasma/Applet -r "$id"
if [[ -d $backup/package ]]; then
    kpackagetool6 -t Plasma/Applet -i "$backup/package"
fi
printf 'Rollback complete. Log out and back in. Panel configuration was not replaced.\n'
