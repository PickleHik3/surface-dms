# surface-dms

DMS plugin repository for the Surface-oriented Hyprland setup.

## Plugin

`Surface Tablet Controls` adds:

- a DankBar button for `qs-hyprview` recent apps
- a DankBar button and popout for `wvkbd` actions:
  - auto
  - show
  - hide
  - disable
- default separate widget variants for:
  - `qs-hyprview`
  - keyboard toggle
  - universal back
  - home

## Default paths

- `qs-hyprview`: `~/.config/hypr/apps/qs-hyprview`
- `wvkbd`: `~/.config/hypr/apps/wvkbd`

## Install

1. Clone this repository into the DMS plugin directory:
   - `mkdir -p ~/.config/DankMaterialShell/plugins`
   - `git clone https://github.com/PickleHik3/surface-dms ~/.config/DankMaterialShell/plugins/surface-dms`
2. Open DMS Settings and go to `Plugins`.
3. Click `Scan for Plugins`.
4. Enable `Surface Tablet Controls`.
5. Open the plugin settings and click `Create Missing Default Variants`.
6. Add the widgets you want to your DankBar layout.
7. Restart the shell with `dms restart`.

## Default variants

The plugin can be used in two ways:

- one grouped widget with recent apps and a keyboard popout
- separate variants that show up as their own DankBar items:
  - `Recent Apps`
  - `Keyboard Toggle`
  - `Back`
  - `Home`

The `Back` variant uses Hyprland's built-in `sendshortcut` dispatcher:

- browser windows: sends `Alt+Left`
- file managers: sends `Alt+Left`
- everything else: sends `Escape`

The `Home` variant:

- defaults to the built-in DMS launcher toggle
- can be overridden in plugin settings with a custom shell command

## Files

- [plugin.json](plugin.json)
- [Main.qml](surface-tablet-controls/Main.qml)
- [Settings.qml](surface-tablet-controls/Settings.qml)

## Notes

- This repository now follows the DMS plugin format directly.
- For plugin registry submission, keep `plugin.json`, this README, and a screenshot in the repository root.
