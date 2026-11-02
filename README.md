# macOS-inspired Control Centre for KDE Plasma 6

A community customization of [Prayag2's Control Centre for KDE](https://github.com/Prayag2/kde_controlcentre), inspired by macOS Control Center. The goal is a rounded, organized quick-settings panel with improved text alignment, audio controls, networking, Bluetooth, appearance controls and media playback.

> **Development status:** This repository currently still contains much of Prayag2's original source, not all of the customized QML used in the maintainer's local setup. Its metadata still identifies the widget as `com.github.prayag2.controlcentre`. Until the actual modifications and a unique ID are committed and tested, this is **not a standalone KDE Store-ready release**.
>
> **Unofficial project:** Not affiliated with Apple or KDE.

## Requirements

- KDE Plasma 6, Qt 6, and a Linux distribution with KDE widget support.
- `git` and `kpackagetool6` for installation from source.
- Plasma Network Management, Plasma Audio and optional KDE Connect integration.
- Some features require a compatible system. For example, an external monitor may not expose brightness controls.

On Fedora KDE, most KDE dependencies are installed already. Install Git and locate the packaging tool:

```bash
sudo dnf install -y git
command -v kpackagetool6
```

If the second command prints nothing, use `dnf provides '*/kpackagetool6'` to find your version's package. If a QML module is missing, investigate the error before installing unrelated packages.

## Installation from GitHub (development source)

**Warning:** The current package uses the *same widget ID as the original Prayag2 project*. Installing it may replace an existing locally installed copy. Back up your modified widget first.

1. Open Konsole.
2. Clone the repository:

```bash
git clone https://github.com/Mkeays501/macos-controlcentre-kde.git
cd macos-controlcentre-kde
```

3. Confirm the package files are present:

```bash
ls package/metadata.json package/contents/ui/main.qml
```

4. Check the ID and make sure you understand which widget will be installed:

```bash
grep '"Id"' package/metadata.json
```

5. Install the widget:

```bash
kpackagetool6 -t Plasma/Applet -i package
```

If the ID is already installed, use `-u` rather than `-i`:

```bash
kpackagetool6 -t Plasma/Applet -u package
```

6. Restart the Plasma shell:

```bash
systemctl --user restart plasma-plasmashell.service
```

7. Right-click the desktop or panel → **Add or Manage Widgets** → search for **Control Centre** → add it to a panel or desktop.

### Updating

From the directory you cloned:

```bash
git pull --ff-only
kpackagetool6 -t Plasma/Applet -u package
systemctl --user restart plasma-plasmashell.service
```

### Uninstalling

Remove any instances from the KDE panel, then run:

```bash
kpackagetool6 -t Plasma/Applet -r com.github.prayag2.controlcentre
systemctl --user restart plasma-plasmashell.service
```

**Caution:** This currently also removes the upstream widget sharing that ID. Once the project has its own ID, replace the command with that ID.

## Troubleshooting

### `NightLightControl is not a type`

On some KDE Plasma 6 versions, the upstream Night Light component in `RedShift.qml` fails to load, preventing the entire widget from opening. As a temporary workaround, comment out the `Components.RedShift{}` line in `package/contents/ui/FullRepresentation.qml`, upgrade the widget, then restart Plasma. This disables only the widget's Night Light shortcut, not KDE's built-in feature.

```bash
cp package/contents/ui/FullRepresentation.qml package/contents/ui/FullRepresentation.qml.bak
sed -i 's/Components\.RedShift{}/\/\/ Components.RedShift{} disabled on this Plasma version/' package/contents/ui/FullRepresentation.qml
kpackagetool6 -t Plasma/Applet -u package
systemctl --user restart plasma-plasmashell.service
```

This substitution only works if the original line is present. If it is absent or has changed, inspect the file and edit the relevant QML component manually.

### Network / Bluetooth / Settings text overlaps

The local alignment fix must be included in the committed QML files before users receive it from GitHub. Check the sizing and row layout in `package/contents/ui/components/SectionButtons.qml`, shared button layouts in `package/contents/ui/lib/LongButton.qml`, and popup sizing in `package/contents/ui/main.qml`.

### Widget appears missing

Check that it installed correctly, verify the QML dependencies, and restart Plasma Shell. For diagnostic logs:

```bash
journalctl --user -b -u plasma-plasmashell.service --no-pager -n 100
```

## Modifying the widget

Source files:

| File | Purpose |
| --- | --- |
| `package/contents/ui/main.qml` | Widget entry point, size and settings |
| `package/contents/ui/FullRepresentation.qml` | Expanded popup arrangement |
| `package/contents/ui/components/SectionButtons.qml` | Network, Bluetooth and Settings block |
| `package/contents/ui/components/Volume.qml` | Volume control |
| `package/contents/ui/components/BrightnessSlider.qml` | Display brightness where supported |
| `package/contents/ui/components/MediaPlayer.qml` | MPRIS media controls |
| `package/contents/ui/lib/` | Shared card, button and slider components |

After modifying QML files, run `kpackagetool6 -t Plasma/Applet -u package`, followed by `systemctl --user restart plasma-plasmashell.service`. Test in a separate user account when possible.

## Preparing for a KDE Store release

**Complete these steps before uploading.** The current repository is not yet release-ready.

1. **Commit the actual redesign** and the alignment fixes into `package/contents/ui/`. A local patched installation does not automatically update GitHub.
2. **Choose a unique plugin identifier**, e.g. `com.github.mkeays501.macoscontrolcentre`, in `package/metadata.json`. Update references in scripts and documentation, then test clean installation and removal. The package must not overwrite Prayag2's widget.
3. **Update metadata:** set a distinct name, accurate version, short description, project website, correct authors and appropriate attribution. Modern Plasma 6 packaging uses `KPackageStructure: Plasma/Applet`; retain `X-Plasma-API-Minimum-Version: 6.0`. Consult the [KDE widget developer documentation](https://develop.kde.org/docs/plasma/widget/setup/) for current metadata conventions.
4. **Retain GPL-3.0 licensing and upstream copyright notices.** Credit [Prayag Jain / Prayag2](https://github.com/Prayag2/kde_controlcentre) and document your modifications.
5. **Test the release:** install, restart, verify interactive controls, remove, reinstall, and update on a clean KDE Plasma 6 account. Check that the known Night Light error no longer prevents loading. Do not claim untested OS compatibility.
6. **Take real screenshots** showing the modified widget's final UI; avoid using promotional mockups as evidence of the installed product.
7. **Create a self-contained release archive:**

```bash
mkdir -p dist
(cd package && zip -qr ../dist/macos-controlcentre-0.1.0.plasmoid metadata.json contents)
unzip -l dist/macos-controlcentre-0.1.0.plasmoid | head -25
```

The archive's root must contain `metadata.json` and `contents/`, **not** an enclosing `package/` directory. Ensure that `zip` and `unzip` are installed if necessary.

8. **Test the exact release artifact** (preferably under a clean user account):

```bash
kpackagetool6 -t Plasma/Applet -i dist/macos-controlcentre-0.1.0.plasmoid
```

If an older copy with the same ID exists, uninstall or upgrade appropriately rather than overwriting blindly.

9. **Create a GitHub Release** with version notes and attach the `.plasmoid` file.
10. **Submit to the KDE Store:** open [store.kde.org](https://store.kde.org/), sign in or create an OpenDesktop/Pling account, look for **Add Product** or **Upload Product**, and choose the **Plasma 6 Applets** category (UI labels may vary). Provide the title, description, screenshots, license, repository link, supported Plasma versions, and the release download. Publish/submit the listing and follow any moderation prompts.
11. After acceptance and indexing, test KDE's **Add or Manage Widgets → Get New Widgets → Download New Plasma Widgets** search for your project. Search visibility may not be immediate.

## Suggested versioning

- `0.1.0` — first independently installable, tested derivative.
- `0.1.1` — small fixes for sizing and compatibility.
- `0.2.0` — substantial design or feature improvements.

## Credits and license
## Credits & Attribution

This project is a **derivative work** of [Control Centre for KDE](https://github.com/Prayag2/kde_controlcentre), originally created by **Prayag Jain (Prayag2)**.

The original project provides the foundation for the widget, including its core QML components and KDE Plasma integrations.

This fork builds upon that work with modifications aimed at providing a more macOS-inspired interface, including:

- Redesigned layouts and visual styling.
- Improved text alignment, spacing, and widget proportions.
- Compatibility adjustments for KDE Plasma 6.
- Additional interface refinements and usability improvements.

**Original author:** Prayag Jain (Prayag2)  
**Original repository:** https://github.com/Prayag2/kde_controlcentre  
**Modified version maintained by:** Mkeays501  
**Fork repository:** https://github.com/Mkeays501/macos-controlcentre-kde

### License
Based on **Control Centre for KDE** by [Prayag Jain (Prayag2)](https://github.com/Prayag2/kde_controlcentre). The upstream project is licensed under the **GNU General Public License v3.0**. Preserve its license and notices when distributing your derivative. This is a community project and is not endorsed by Apple Inc. or KDE.
This project is distributed under the **GNU General Public License v3.0 (GPL-3.0)**, consistent with the original project.

The original author's copyright and attribution are retained. Modifications made in this fork are provided under the same license.

### Disclaimer

This project is independently maintained and is not an official release of the original Control Centre for KDE project. It is not affiliated with or endorsed by Prayag2, the KDE community, or Apple Inc.

All credit for the original implementation belongs to its respective author. This project is intended as a community-driven customization and extension of that work.

