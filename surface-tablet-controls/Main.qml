import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    pluginId: "surfaceTabletControls"
    layerNamespacePlugin: "surface-tablet-controls"

    property string variantId: ""
    property var variantData: null
    property string lastAction: ""
    property string lastError: ""

    readonly property bool isVariant: variantData !== null
    readonly property string actionKind: variantData && variantData.action ? variantData.action : "menu"
    readonly property string variantIcon: variantData && variantData.icon ? variantData.icon : "widgets"
    readonly property string recentAppsPath: pluginData.recentAppsPath || "$HOME/.config/hypr/apps/qs-hyprview"
    readonly property string keyboardAutoScript: pluginData.keyboardAutoScript || "$HOME/.config/hypr/apps/wvkbd/scripts/auto-show-wvkbd.sh"
    readonly property string keyboardShowScript: pluginData.keyboardShowScript || "$HOME/.config/hypr/apps/wvkbd/scripts/show-wvkbd.sh"
    readonly property string keyboardHideScript: pluginData.keyboardHideScript || "$HOME/.config/hypr/apps/wvkbd/scripts/hide-wvkbd.sh"
    readonly property string keyboardDisableScript: pluginData.keyboardDisableScript || "$HOME/.config/hypr/apps/wvkbd/scripts/disable-wvkbd.sh"
    readonly property string homeCommand: pluginData.homeCommand || ""
    readonly property int actionButtonSize: Math.max(30, iconSize + Theme.spacingS)
    readonly property string browserClassRegex: "^(firefox|org\\.mozilla\\.firefox|librewolf|floorp|zen|zen-browser|chromium|google-chrome|google-chrome-beta|google-chrome-unstable|brave-browser|com\\.brave\\.Browser|microsoft-edge|microsoft-edge-beta|com\\.microsoft\\.Edge|vivaldi|vivaldi-stable)$"
    readonly property string fileManagerClassRegex: "^(org\\.gnome\\.Nautilus|nautilus|thunar|org\\.xfce\\.Thunar|dolphin|org\\.kde\\.dolphin|pcmanfm|pcmanfm-qt|nemo|org\\.cinnamon\\.Nemo)$"

    function shellQuote(value) {
        return "'" + String(value).replace(/'/g, "'\"'\"'") + "'";
    }

    function expandHome(value) {
        const home = Quickshell.env("HOME") || "";
        const text = String(value || "");
        if (!home)
            return text;
        if (text === "$HOME")
            return home;
        if (text.indexOf("$HOME/") === 0)
            return home + text.slice(5);
        return text;
    }

    function createDefaultVariants(forceCreate) {
        if (!pluginService)
            return;

        const defaults = [
            { name: "Recent Apps", action: "recentApps", icon: "apps" },
            { name: "Keyboard Toggle", action: "keyboardToggle", icon: "keyboard" },
            { name: "Back", action: "back", icon: "arrow_back" },
            { name: "Home", action: "home", icon: "home" }
        ];
        const existingActions = {};

        for (let i = 0; i < variants.length; i++) {
            const item = variants[i];
            if (item && item.action)
                existingActions[item.action] = true;
        }

        for (let i = 0; i < defaults.length; i++) {
            const item = defaults[i];
            if (!forceCreate && existingActions[item.action])
                continue;
            createVariant(item.name, item);
        }
    }

    function ensureDefaultVariants() {
        if (!pluginService)
            return;
        if (pluginData.defaultVariantsCreated)
            return;

        createDefaultVariants(false);
        pluginService.savePluginData(pluginId, "defaultVariantsCreated", true);
    }

    function runShell(script, actionLabel) {
        root.lastAction = actionLabel || "";
        root.lastError = "";
        executor.exec({
            command: ["bash", "-lc", script]
        });
    }

    function runScriptPath(scriptPath, actionLabel) {
        runShell(shellQuote(scriptPath), actionLabel);
    }

    function runVariantAction() {
        if (actionKind === "recentApps")
            openRecentApps();
        else if (actionKind === "keyboardToggle")
            keyboardToggle();
        else if (actionKind === "back")
            universalBack();
        else if (actionKind === "home")
            homeAction();
        else
            triggerPopout();
    }

    function openRecentApps() {
        runShell("quickshell ipc -p " + shellQuote(expandHome(recentAppsPath)) + " call expose open smartgrid", "Recent apps");
    }

    function keyboardToggle() {
        const toggleScript = [
            "STATE_DIR=\"/run/user/${UID}/wvkbd-custom\"",
            "DISABLED_FLAG=\"${STATE_DIR}/disabled\"",
            "mkdir -p \"${STATE_DIR}\"",
            "if [[ -f \"${DISABLED_FLAG}\" ]]; then",
            "  " + shellQuote(expandHome(keyboardAutoScript)),
            "else",
            "  " + shellQuote(expandHome(keyboardDisableScript)),
            "fi"
        ].join("\n");
        runShell(toggleScript, "Keyboard toggle");
    }

    function keyboardAuto() {
        runScriptPath(expandHome(keyboardAutoScript), "Keyboard auto");
        closePopout();
    }

    function keyboardShow() {
        runScriptPath(expandHome(keyboardShowScript), "Keyboard show");
        closePopout();
    }

    function keyboardHide() {
        runScriptPath(expandHome(keyboardHideScript), "Keyboard hide");
        closePopout();
    }

    function keyboardDisable() {
        runScriptPath(expandHome(keyboardDisableScript), "Keyboard disable");
        closePopout();
    }

    function homeAction() {
        const customCommand = String(homeCommand || "").trim();
        if (customCommand !== "") {
            runShell(customCommand, "Home");
            return;
        }
        root.lastAction = "Home";
        root.lastError = "";
        if (popoutService)
            popoutService.toggleDankLauncherV2();
    }

    function universalBack() {
        if (popoutService && popoutService.controlCenterPopout && popoutService.controlCenterPopout.shouldBeVisible) {
            popoutService.closeControlCenter();
            root.lastAction = "Back";
            root.lastError = "";
            return;
        }
        if (popoutService && popoutService.notificationCenterPopout && popoutService.notificationCenterPopout.shouldBeVisible) {
            popoutService.closeNotificationCenter();
            root.lastAction = "Back";
            root.lastError = "";
            return;
        }
        if (popoutService && popoutService.appDrawerPopout && popoutService.appDrawerPopout.shouldBeVisible) {
            popoutService.closeAppDrawer();
            root.lastAction = "Back";
            root.lastError = "";
            return;
        }
        if (popoutService && popoutService.processListPopout && popoutService.processListPopout.shouldBeVisible) {
            popoutService.closeProcessList();
            root.lastAction = "Back";
            root.lastError = "";
            return;
        }
        if (popoutService && popoutService.dankDashPopout && popoutService.dankDashPopout.dashVisible) {
            popoutService.closeDankDash();
            root.lastAction = "Back";
            root.lastError = "";
            return;
        }
        if (popoutService && popoutService.settingsModal && (popoutService.settingsModal.visible || popoutService.settingsModal.shouldBeVisible)) {
            popoutService.closeSettings();
            root.lastAction = "Back";
            root.lastError = "";
            return;
        }
        if (popoutService && popoutService.clipboardHistoryModal && (popoutService.clipboardHistoryModal.visible || popoutService.clipboardHistoryModal.shouldBeVisible)) {
            popoutService.clipboardHistoryModal.close();
            root.lastAction = "Back";
            root.lastError = "";
            return;
        }
        if (popoutService && popoutService.dankLauncherV2Modal && (popoutService.dankLauncherV2Modal.spotlightOpen || popoutService.dankLauncherV2Modal.visible)) {
            popoutService.closeDankLauncherV2();
            root.lastAction = "Back";
            root.lastError = "";
            return;
        }
        if (popoutService && popoutService.powerMenuModal && (popoutService.powerMenuModal.visible || popoutService.powerMenuModal.shouldBeVisible)) {
            popoutService.powerMenuModal.close();
            root.lastAction = "Back";
            root.lastError = "";
            return;
        }

        const backScript = [
            "active_class=\"$(hyprctl -j activewindow | jq -r '(.class // .initialClass // \"\")')\"",
            "if [[ -z \"${active_class}\" || \"${active_class}\" == \"null\" ]]; then",
            "  exit 0",
            "fi",
            "shopt -s nocasematch",
            "if [[ \"${active_class}\" =~ " + browserClassRegex + " ]]; then",
            "  hyprctl dispatch sendshortcut ALT,left,activewindow",
            "elif [[ \"${active_class}\" =~ " + fileManagerClassRegex + " ]]; then",
            "  hyprctl dispatch sendshortcut ALT,left,activewindow",
            "else",
            "  hyprctl dispatch sendshortcut ,escape,activewindow",
            "fi"
        ].join("\n");
        runShell(backScript, "Back");
    }

    Component.onCompleted: {
        Qt.callLater(root.ensureDefaultVariants);
    }

    onPluginServiceChanged: {
        Qt.callLater(root.ensureDefaultVariants);
    }

    horizontalBarPill: Component {
        Loader {
            sourceComponent: root.isVariant ? variantPillHorizontal : groupedPillHorizontal
        }
    }

    verticalBarPill: Component {
        Loader {
            sourceComponent: root.isVariant ? variantPillVertical : groupedPillVertical
        }
    }

    property Component variantPillHorizontal: Component {
        ActionButton {
            buttonSize: root.actionButtonSize
            iconName: root.variantIcon
            iconColor: root.actionKind === "recentApps" ? Theme.primary : Theme.surfaceText
            onClicked: root.runVariantAction()
        }
    }

    property Component variantPillVertical: Component {
        ActionButton {
            buttonSize: root.actionButtonSize
            iconName: root.variantIcon
            iconColor: root.actionKind === "recentApps" ? Theme.primary : Theme.surfaceText
            onClicked: root.runVariantAction()
        }
    }

    property Component groupedPillHorizontal: Component {
        Row {
            spacing: Theme.spacingXS

            ActionButton {
                buttonSize: root.actionButtonSize
                iconName: "apps"
                iconColor: Theme.primary
                onClicked: root.openRecentApps()
            }

            ActionButton {
                buttonSize: root.actionButtonSize
                iconName: "keyboard"
                iconColor: Theme.surfaceText
                onClicked: root.triggerPopout()
            }
        }
    }

    property Component groupedPillVertical: Component {
        Column {
            spacing: Theme.spacingXS

            ActionButton {
                buttonSize: root.actionButtonSize
                iconName: "apps"
                iconColor: Theme.primary
                onClicked: root.openRecentApps()
            }

            ActionButton {
                buttonSize: root.actionButtonSize
                iconName: "keyboard"
                iconColor: Theme.surfaceText
                onClicked: root.triggerPopout()
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            id: popout

            headerText: "Surface Tablet Controls"
            detailsText: "Recent apps and wvkbd actions for the tablet workflow."
            showCloseButton: true

            Item {
                width: parent.width
                implicitHeight: contentColumn.implicitHeight

                Column {
                    id: contentColumn
                    width: parent.width
                    spacing: Theme.spacingM

                    StyledText {
                        width: parent.width
                        text: "Recent apps"
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.surfaceVariantText
                    }

                    DankButton {
                        width: parent.width
                        text: "Open qs-hyprview"
                        iconName: "apps"
                        onClicked: root.openRecentApps()
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.outline
                        opacity: 0.3
                    }

                    StyledText {
                        width: parent.width
                        text: "Keyboard"
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.surfaceVariantText
                    }

                    DankButton {
                        width: parent.width
                        text: "Auto + show now"
                        iconName: "keyboard"
                        onClicked: root.keyboardAuto()
                    }

                    DankButton {
                        width: parent.width
                        text: "Show"
                        iconName: "keyboard"
                        onClicked: root.keyboardShow()
                    }

                    DankButton {
                        width: parent.width
                        text: "Hide"
                        iconName: "keyboard_hide"
                        onClicked: root.keyboardHide()
                    }

                    DankButton {
                        width: parent.width
                        text: "Disable"
                        iconName: "block"
                        onClicked: root.keyboardDisable()
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.outline
                        opacity: 0.3
                    }

                    StyledText {
                        width: parent.width
                        text: "Navigation"
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.surfaceVariantText
                    }

                    DankButton {
                        width: parent.width
                        text: "Universal back"
                        iconName: "arrow_back"
                        onClicked: root.universalBack()
                    }

                    DankButton {
                        width: parent.width
                        text: "Home"
                        iconName: "home"
                        onClicked: root.homeAction()
                    }

                    StyledText {
                        width: parent.width
                        visible: root.lastAction !== "" && root.lastError === ""
                        text: "Last action: " + root.lastAction
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                    }

                    StyledText {
                        width: parent.width
                        visible: root.lastError !== ""
                        text: root.lastError
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.error
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }

    popoutWidth: 360
    popoutHeight: 420

    Process {
        id: executor

        stdout: StdioCollector {
            onStreamFinished: {
                if (text && text.trim().length > 0)
                    console.log("SurfaceTabletControls:", text.trim());
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text && text.trim().length > 0) {
                    root.lastError = text.trim();
                    ToastService.showError("Surface Tablet Controls", root.lastError);
                }
            }
        }

        onExited: exitCode => {
            if (exitCode !== 0 && !root.lastError) {
                root.lastError = "Command failed with exit code " + exitCode;
                ToastService.showError("Surface Tablet Controls", root.lastError);
            }
        }
    }
}
