import QtQuick
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root

    pluginId: "surfaceTabletControls"

    StyledText {
        width: parent.width
        text: "Surface Tablet Controls"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "Configure the qs-hyprview target path and the wvkbd helper scripts used by the widget."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "Default widget variants are Recent Apps, Keyboard Toggle, Back, and Home. After enabling the plugin, add those variants from DankBar settings as separate items."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    DankButton {
        width: parent.width
        text: "Create Missing Default Variants"
        iconName: "widgets"
        onClicked: {
            const defaults = [
                { name: "Recent Apps", action: "recentApps", icon: "grid_view" },
                { name: "Keyboard Toggle", action: "keyboardToggle", icon: "keyboard" },
                { name: "Back", action: "back", icon: "arrow_back" },
                { name: "Home", action: "home", icon: "home" }
            ];
            const existingActions = {};

            for (let i = 0; i < root.variants.length; i++) {
                const item = root.variants[i];
                if (item && item.action)
                    existingActions[item.action] = true;
            }

            let created = 0;
            for (let i = 0; i < defaults.length; i++) {
                const item = defaults[i];
                if (existingActions[item.action])
                    continue;
                createVariant(item.name, item);
                created += 1;
            }

            root.saveValue("defaultVariantsCreated", true);
            if (created > 0)
                ToastService.showInfo("Surface Tablet Controls", "Created " + created + " widget variants");
            else
                ToastService.showInfo("Surface Tablet Controls", "All default widget variants already exist");
        }
    }

    StringSetting {
        settingKey: "recentAppsPath"
        label: "qs-hyprview path"
        description: "Path passed to quickshell ipc -p for the recent apps view."
        defaultValue: "$HOME/.config/hypr/apps/qs-hyprview"
        placeholder: "$HOME/.config/hypr/apps/qs-hyprview"
    }

    StringSetting {
        settingKey: "keyboardAutoScript"
        label: "Keyboard auto script"
        description: "Script that enables auto mode and shows the keyboard."
        defaultValue: "$HOME/.config/hypr/apps/wvkbd/scripts/auto-show-wvkbd.sh"
        placeholder: "$HOME/.config/hypr/apps/wvkbd/scripts/auto-show-wvkbd.sh"
    }

    StringSetting {
        settingKey: "keyboardShowScript"
        label: "Keyboard show script"
        description: "Script that forces the keyboard visible."
        defaultValue: "$HOME/.config/hypr/apps/wvkbd/scripts/show-wvkbd.sh"
        placeholder: "$HOME/.config/hypr/apps/wvkbd/scripts/show-wvkbd.sh"
    }

    StringSetting {
        settingKey: "keyboardHideScript"
        label: "Keyboard hide script"
        description: "Script that hides the keyboard."
        defaultValue: "$HOME/.config/hypr/apps/wvkbd/scripts/hide-wvkbd.sh"
        placeholder: "$HOME/.config/hypr/apps/wvkbd/scripts/hide-wvkbd.sh"
    }

    StringSetting {
        settingKey: "keyboardDisableScript"
        label: "Keyboard disable script"
        description: "Script that disables the keyboard automation hook."
        defaultValue: "$HOME/.config/hypr/apps/wvkbd/scripts/disable-wvkbd.sh"
        placeholder: "$HOME/.config/hypr/apps/wvkbd/scripts/disable-wvkbd.sh"
    }

    StringSetting {
        settingKey: "homeCommand"
        label: "Home button command"
        description: "Optional custom shell command for the Home variant. Leave empty to use the built-in DMS launcher toggle."
        defaultValue: ""
        placeholder: "dms ipc launcher toggle"
    }
}
