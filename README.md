# Liquid Glass Control Centre — Plasma 6

A GPLv3 replacement source package for [Mkeays501/macos-controlcentre-kde](https://github.com/Mkeays501/macos-controlcentre-kde), based on commit `8779405acd0afc06c7afe836b2c8c23bdc2beb75`.

This derivative retains the work and attribution of **Prayag Jain (Prayag2)**, original author of [Control Centre for KDE](https://github.com/Prayag2/kde_controlcentre), and **Mkeays501**, maintainer of the macOS-inspired derivative. Original LICENSE files and author metadata are retained. Layout, original geometric SVG icons, packaging and compatibility modifications were prepared on 2026-11-03 and are distributed under GPL-3.0. See LICENSE and package/LICENSE. No Apple assets are included.

The reference screenshot guides the proportions: a connectivity pill beside a tall media card, round Bluetooth controls, a Focus pill and utility buttons, wide Display/Sound sliders, and round shortcuts. The screenshot's AirDrop position opens Bluetooth device settings; other Apple-only features are replaced by labelled KDE settings. Tooltips and keyboard focus explain the icon-only controls.

This is a glass-inspired approximation using translucent gradients, highlights, rounded borders and vector icons. It does not implement Apple's proprietary refraction or reproduce macOS pixel for pixel. Actual translucency/blur depends on Plasma's popup, Plasma theme and KWin compositor; this package does not force global blur or change your desktop theme. At 100%, the preferred popup is 416 × 640 logical pixels, with scrolling on short screens. A system-tray container can impose its own dimensions.

## Controls

| Control | KDE behavior |
| --- | --- |
| Network / Wi-Fi pill | Opens existing network list, Wi-Fi/airplane toggles; saved connections can activate/deactivate. Unsaved connections open KDE's network editor for credentials. |
| Bluetooth circle | Powers adapters and changes BluezQt block state; disabled if no adapter exists. |
| Plus circle | Opens Bluetooth pairing/settings; not AirDrop. |
| Focus | KDE notification inhibition / Do Not Disturb; shows backend state. Mirrored-screen policy can keep inhibition active. |
| Media | MPRIS artwork, title, artist, previous/play-pause/next; unavailable controls disabled. |
| Display | First exposed screen's brightness (or legacy single-screen backend). Not every external monitor supports it. |
| Sound | Preferred output volume, 0–100%, mute/unmute. Moving the slider unmutes. |
| Display / Sound utility circles | KDE display/audio configuration. |
| Bottom circles | Configured light/dark color scheme, System Settings, Night Light settings, Spectacle screenshot app. |
| Edit Controls | Opens this widget's standard Plasma configuration, not a macOS drag-and-drop editor. |
| Optional extras | KDE Connect (loaded only if enabled) and two custom commands in an extra row. |

Spectacle must be installed for the screenshot shortcut. Custom commands execute as your user only when clicked. New defaults are blank; existing saved commands and settings are retained on upgrade. Theme switching accepts simple scheme identifiers such as BreezeDark; scheme names containing spaces are intentionally rejected.

## Download and install

Read **[INSTALL.md](INSTALL.md)** first. The easiest reversible route is to extract the complete source ZIP and run `bash scripts/install.sh`. It saves the exact existing user package and a reference copy of panel settings, prints a rollback command, and never restarts Plasma automatically. Do not use sudo.

The widget ID remains `com.github.mkeays501.macoscontrolcentre`, so this replaces that derivative. It does not overwrite `com.github.prayag2.controlcentre`.

The `.plasmoid` is a ZIP with `metadata.json`, `contents/` and `LICENSE` at its root, following [KDE's widget package structure](https://develop.kde.org/docs/plasma/widget/setup/). No native build is needed. Optional CMake installation has been updated from KF5 to Plasma 6; it requires ECM 6 and Plasma 6 development packages.

## Verification and limits

See **[TESTING.md](TESTING.md)** for exact checks and remaining desktop tests. This is a reviewable candidate, not a claim of compatibility with every Plasma 6 minor version. Private QML APIs can change. Version 1.1.1 is a development update. See the known issues below before installing.

## Version 1.1.1 downloads and known issues

[Download the installable widget](dist/liquid-glass-controlcentre-1.1.1.plasmoid?raw=true), or use GitHub’s Code → Download ZIP for the complete source and backup/rollback scripts.

The first user desktop screenshot confirms that the popup opens, but shows scrolling with Edit Controls below the visible area, some icons rendered as fallback squares/documents, and a more opaque frame/material than the reference. These issues remain under investigation; the offscreen preview does not prove identical rendering in a real Plasma popup. This update is not a finished pixel-perfect theme.

Version 1.1.1 replaces bundled icon rendering with direct SVG images. This targets the missing Display and Sound glyphs; it has passed offscreen rendering but still needs confirmation on the affected desktop.
