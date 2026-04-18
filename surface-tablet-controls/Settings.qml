import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root

    property var pluginApi: null
    property var cfg: pluginApi?.pluginSettings || ({})
    property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

    property string editRecentAppsPath: cfg.recentAppsPath ?? defaults.recentAppsPath ?? ""
    property string editKeyboardAutoScript: cfg.keyboardAutoScript ?? defaults.keyboardAutoScript ?? ""
    property string editKeyboardShowScript: cfg.keyboardShowScript ?? defaults.keyboardShowScript ?? ""
    property string editKeyboardHideScript: cfg.keyboardHideScript ?? defaults.keyboardHideScript ?? ""
    property string editKeyboardDisableScript: cfg.keyboardDisableScript ?? defaults.keyboardDisableScript ?? ""

    spacing: Style.marginL

    NTextInput {
        Layout.fillWidth: true
        label: "qs-hyprview path"
        description: "Path passed to quickshell ipc -p"
        text: root.editRecentAppsPath
        onEditingFinished: root.editRecentAppsPath = text
    }

    NTextInput {
        Layout.fillWidth: true
        label: "Keyboard auto script"
        text: root.editKeyboardAutoScript
        onEditingFinished: root.editKeyboardAutoScript = text
    }

    NTextInput {
        Layout.fillWidth: true
        label: "Keyboard show script"
        text: root.editKeyboardShowScript
        onEditingFinished: root.editKeyboardShowScript = text
    }

    NTextInput {
        Layout.fillWidth: true
        label: "Keyboard hide script"
        text: root.editKeyboardHideScript
        onEditingFinished: root.editKeyboardHideScript = text
    }

    NTextInput {
        Layout.fillWidth: true
        label: "Keyboard disable script"
        text: root.editKeyboardDisableScript
        onEditingFinished: root.editKeyboardDisableScript = text
    }

    function saveSettings() {
        if (!pluginApi)
            return;
        pluginApi.pluginSettings.recentAppsPath = root.editRecentAppsPath;
        pluginApi.pluginSettings.keyboardAutoScript = root.editKeyboardAutoScript;
        pluginApi.pluginSettings.keyboardShowScript = root.editKeyboardShowScript;
        pluginApi.pluginSettings.keyboardHideScript = root.editKeyboardHideScript;
        pluginApi.pluginSettings.keyboardDisableScript = root.editKeyboardDisableScript;
        pluginApi.saveSettings();
    }
}
