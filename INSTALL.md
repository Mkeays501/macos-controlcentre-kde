# Install and roll back

## Recommended: complete source ZIP

1. Extract `liquid-glass-controlcentre-1.1.1-source.zip`. Open a terminal in its `liquid-glass-controlcentre-1.1.1` directory.
2. Close the widget popup. Read `scripts/install.sh`, then run as your desktop user:

```bash
bash scripts/install.sh
```

The script requires `kpackagetool6`. It backs up the existing user package from `${XDG_DATA_HOME:-$HOME/.local/share}/plasma/plasmoids/com.github.mkeays501.macoscontrolcentre` into a new directory under `${XDG_STATE_HOME:-$HOME/.local/state}/macos-controlcentre-backups`. The backup path and exact rollback command are printed. Keep both the extracted source and backup.

It copies `plasma-org.kde.plasma.desktop-appletsrc` as a reference, if present. It does not change panel configuration, use sudo, install system packages, or restart the shell.

3. Log out of KDE and log back in. Save work first. Alternatively, on systems using its user service, run `systemctl --user restart plasma-plasmashell.service`; this briefly removes panels. If that service is absent, use the logout route.
4. Existing instances keep the same ID. For a new installation, add **Liquid Glass Control Centre** from Plasma's widget picker.
5. Open **Edit Controls → Appearance**. Enable transparency if your old configuration has it disabled. Start at 100% scale. Existing settings override new defaults. Optional KDE Connect requires its QML integration installed.

If installation fails, keep the printed backup. Do not delete the old directory or unrelated widgets. Read the reported missing module/error and see TESTING.md.

## Rollback

Use the exact command printed by the installer, for example:

```bash
bash scripts/rollback.sh /absolute/path/to/backup-XXXXXXXX
```

Close the popup first. The script saves the current package too when restoring an older one, removes only `com.github.mkeays501.macoscontrolcentre`, and reinstalls the saved package. For a fresh installation with no previous user package, it removes the new package (revealing any system-installed copy). Log out and back in afterward.

The rollback deliberately retains current widget settings and panel instances. It is not a full desktop reset. If you changed custom commands or visibility settings after installing, those settings stay. Do not copy the whole `desktop-appletsrc.reference` over a running Plasma session: doing so can lose later panel edits. For exact panel restoration, log out fully and restore that reference from another login/TTY only after separately backing up the current file.

If an install or rollback was interrupted, inspect the backup's `package/metadata.json`. A complete saved package can be installed with `kpackagetool6 -t Plasma/Applet -i /absolute/path/to/backup/package` after removing a conflicting copy of this exact ID. Do not remove Prayag2's original widget.

## Standalone .plasmoid

The source script is preferred because it automates backups. If using Plasma's “Install Widget From Local File” or `kpackagetool6` directly, first copy your exact existing user package directory and panel settings somewhere safe. Install with:

```bash
kpackagetool6 -t Plasma/Applet -i /path/to/liquid-glass-controlcentre-1.1.1.plasmoid
```

Use `-u` instead of `-i` when this ID is already installed locally. Log out/in to reload. To roll back a manually installed package, remove only this ID with `kpackagetool6 -t Plasma/Applet -r com.github.mkeays501.macoscontrolcentre`, then install your saved package with `-i` and log out/in.

## Apply the patch to a repository checkout

Use a clean checkout of base commit `8779405acd0afc06c7afe836b2c8c23bdc2beb75`. Save any local changes first; the archive cannot include uncommitted customizations from your computer.

```bash
git status --short
git rev-parse HEAD
git apply --check /path/to/liquid-glass-controlcentre-1.1.1.patch
git apply /path/to/liquid-glass-controlcentre-1.1.1.patch
bash scripts/install.sh
```

The patch includes complete changes and new icons/scripts/docs. To reverse source changes, first ensure none of the patched files has subsequent edits, then run `git apply -R --check /path/to/liquid-glass-controlcentre-1.1.1.patch` and `git apply -R /path/to/liquid-glass-controlcentre-1.1.1.patch`. Source reversal does not restore an installed package; use the package rollback as well.

## Troubleshooting

- **Missing QML module:** inspect `journalctl --user -b -u plasma-plasmashell.service -n 100 --no-pager`. Install the matching distribution package for the named module. Do not mix Qt/KDE versions.
- **Brightness unavailable:** PowerDevil and hardware support are required. This slider controls the first screen exposed by the backend. KDE's display settings handle other screens.
- **No media:** start an MPRIS-capable player. Artwork comes from the player.
- **Network credentials:** new connections open KDE's editor; use Plasma's standard network applet if the editor cannot complete a specific connection.
- **Focus remains enabled:** another application or KDE's mirrored-display policy can continue inhibiting notifications. Change that policy through KDE notification settings.
- **Looks more opaque:** enable the widget's Transparency option. Plasma theme and compositor behavior also affect the result. No global desktop effects are changed by this package.
