# Verification — 2026-11-03

## Completed

- Inspected actual source at upstream commit `8779405acd0afc06c7afe836b2c8c23bdc2beb75` and recovered both attached reference screenshots from the linked conversation.
- Compiled all **25 QML files** (including main.qml and configuration pages) with QQmlComponent and installed KDE modules, Qt **6.11.2**: **zero compile errors**. A qmllint symlink was present but its executable was absent, so this uses the Qt QML compiler rather than claiming a qmllint pass.
- Created and rendered FullRepresentation in an offscreen Qt Quick harness with real KDE backend modules, mock applet configuration and a fixed dark backdrop: no QML runtime errors reported. The harness supplies the applet's context; it is not a full plasmashell integration test.
- Visually reviewed the rendered UI and corrected text overflow, circular selection fills and icon contrast. Original monochrome SVGs avoid dependencies on a particular installed icon theme.
- The preview PNG is that offscreen render with no media playing. It does not demonstrate compositor blur, proprietary refraction, or every state of the controls.
- Installed the exact `.plasmoid` using kpackagetool6 into a separate package root; verified ZIP integrity and root entries.
- Tested the bundled install/rollback scripts with real kpackagetool6 and temporary XDG data/config/state/cache directories: fresh installation and removal; upgrade from the base package; backup and rollback. Compared every restored package file's SHA-256: byte-identical to the original package. Live panel settings were not modified.
- `bash -n` on both scripts and `git diff --check` passed.
- Generated a patch against the pinned base; checked forward application, exact resulting file contents, and reverse applicability.

## Not claimed

No CMake/native build was run: cmake and Plasma development files are unavailable in this environment. This QML-only package installs directly through kpackagetool6; CMake is an optional packaging path, updated to Plasma 6 but unverified here.

No controls were clicked to change the user's network, Bluetooth, notification policy, volume, brightness, color scheme or screenshot state. No actual media session or physical device transition was exercised. The renderer read available backend state. Compile/render and package installation checks cannot establish all interactive behavior. Plasma 6 private modules are version sensitive; all minor versions have not been tested. Legacy and per-display brightness code paths are present, but physical operation of both paths is unverified. Compositor blur and GPU rendering were not tested; rendering used the software backend.

## Reproduce compilation

With PySide6 and matching Plasma QML modules installed:

```bash
dbus-run-session -- python3 tests/compile_qml.py
```

Use a disposable user session for interactive validation. Check the following before treating this as a production release:

1. Add to a horizontal panel, a vertical panel, the desktop and (if needed) the system tray. Open/close the popup and Edit Controls; test scales 50%, 100%, 150%, 200%, shorter screens and long/localized strings.
2. Open network list; connect/disconnect a saved connection; verify Wi-Fi and airplane toggles; create a new secure network through KDE's editor. Do not disconnect a remote management session.
3. Test Bluetooth with no adapter, a powered-off adapter, a paired device and pairing through the plus shortcut.
4. Toggle Focus and observe notification behavior and mirrored-display policy. Verify the off state again after testing.
5. Start an MPRIS player, confirm artwork/title, pause/resume and skip, then close it. Check disabled no-player controls.
6. Test volume with and without an output, muted/unmuted; drag the slider and verify hardware/backend state. Test Display with compatible backlight/DDC hardware; only the first backend display is controlled.
7. Launch display/audio/settings/Night Light configuration and Spectacle. Confirm configured color schemes exist. Enable KDE Connect only when its integration is installed. Test explicit custom commands, never unreviewed commands.
8. Check transparent and opaque modes, your actual Plasma theme/KWin compositor, keyboard navigation, tooltips and screen-reader labels.
9. Install, update and roll back using the included scripts, then review shell logs for QML errors.

Useful diagnostic: `journalctl --user -b -u plasma-plasmashell.service -n 100 --no-pager`.

Primary implementation references: [KDE widget structure](https://develop.kde.org/docs/plasma/widget/setup/), [KDE brightness model](https://github.com/KDE/powerdevil/blob/master/applets/brightness/PopupDialog.qml), and installed KDE QML type descriptions for Network Management, MPRIS, notifications and brightness.

## First desktop feedback

A user-provided Plasma screenshot confirms the installed popup opens. It also shows a scrollbar hiding Edit Controls below the fold, several fallback icons, and opaque framing/material. These are known unresolved visual issues in 1.1.0. Physical control behavior remains unverified.

## Icon hotfix 1.1.1

All QML components compiled without errors; the direct SVG renderer loaded in an offscreen harness and showed the Display and Sound icons. SVG XML parsing passed for all 15 bundled assets. The affected user's desktop has not yet been retested. This does not resolve the earlier popup framing and scrolling reports.
