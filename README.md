# surface-noctalia

Custom Noctalia plugin repository for my Surface-oriented Hyprland setup.

## Included plugin

- `surface-tablet-controls`: bar controls for:
  - opening `qs-hyprview` recent apps
  - running the existing `wvkbd` helper scripts: auto, show, hide, disable

## Repository layout

This repository follows Noctalia's custom plugin repository format:

```text
surface-noctalia/
├── registry.json
└── surface-tablet-controls/
    ├── manifest.json
    ├── Main.qml
    ├── BarWidget.qml
    ├── Panel.qml
    ├── Settings.qml
    ├── README.md
    └── preview.png
```

## Default paths expected by the plugin

- `qs-hyprview`: `~/.config/hypr/apps/qs-hyprview`
- `wvkbd`: `~/.config/hypr/apps/wvkbd`

## For Noctalia users

Push this repository to GitHub, then add that repository URL in the Noctalia Shell plugins UI as a custom repository.
