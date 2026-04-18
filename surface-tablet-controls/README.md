# Surface Tablet Controls

Noctalia Shell plugin for my Hyprland tablet setup.

## What it does

- adds a bar button to open a small panel with `wvkbd` actions
- adds a bar button to open `qs-hyprview` recent apps
- uses the existing scripts and paths from my Hyprland setup

## Default paths

- `qs-hyprview`: `~/.config/hypr/apps/qs-hyprview`
- `wvkbd`: `~/.config/hypr/apps/wvkbd`

## Commands exposed through plugin IPC

```bash
qs -c noctalia-shell ipc call plugin:surface-tablet-controls recentApps
qs -c noctalia-shell ipc call plugin:surface-tablet-controls keyboardAuto
qs -c noctalia-shell ipc call plugin:surface-tablet-controls keyboardShow
qs -c noctalia-shell ipc call plugin:surface-tablet-controls keyboardHide
qs -c noctalia-shell ipc call plugin:surface-tablet-controls keyboardDisable
```
