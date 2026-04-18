import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""
    property int sectionWidgetIndex: -1
    property int sectionWidgetsCount: 0

    readonly property var mainInstance: pluginApi?.mainInstance
    readonly property real capsuleSize: Style.getCapsuleHeightForScreen(screen?.name)

    implicitWidth: keyboardButton.width + overviewButton.width + row.spacing
    implicitHeight: capsuleSize

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: Style.marginXS

        NIconButton {
            id: keyboardButton
            Layout.preferredWidth: root.capsuleSize
            Layout.preferredHeight: root.capsuleSize
            icon: "keyboard"
            tooltipText: "Keyboard actions"
            tooltipDirection: BarService.getTooltipDirection(screen?.name)
            baseSize: root.capsuleSize
            applyUiScale: false
            customRadius: Style.radiusL
            colorBg: Style.capsuleColor
            colorFg: Color.mOnSurface
            border.color: Style.capsuleBorderColor
            border.width: Style.capsuleBorderWidth

            onClicked: {
                if (pluginApi)
                    pluginApi.togglePanel(root.screen, keyboardButton);
            }

            onRightClicked: {
                PanelService.showContextMenu(contextMenu, keyboardButton, screen);
            }
        }

        NIconButton {
            id: overviewButton
            Layout.preferredWidth: root.capsuleSize
            Layout.preferredHeight: root.capsuleSize
            icon: "layout-dashboard"
            tooltipText: "Open recent apps"
            tooltipDirection: BarService.getTooltipDirection(screen?.name)
            baseSize: root.capsuleSize
            applyUiScale: false
            customRadius: Style.radiusL
            colorBg: Style.capsuleColor
            colorFg: Color.mPrimary
            border.color: Style.capsuleBorderColor
            border.width: Style.capsuleBorderWidth

            onClicked: {
                mainInstance?.openRecentApps();
            }

            onRightClicked: {
                PanelService.showContextMenu(contextMenu, overviewButton, screen);
            }
        }
    }

    NPopupContextMenu {
        id: contextMenu

        model: [
            { "label": "Recent apps", "action": "recent", "icon": "layout-dashboard" },
            { "label": "Keyboard auto", "action": "auto", "icon": "keyboard-show" },
            { "label": "Keyboard show", "action": "show", "icon": "keyboard" },
            { "label": "Keyboard hide", "action": "hide", "icon": "keyboard-hide" },
            { "label": "Keyboard disable", "action": "disable", "icon": "keyboard-off" },
            { "label": "Settings", "action": "settings", "icon": "settings" }
        ]

        onTriggered: function(action) {
            contextMenu.close();
            PanelService.closeContextMenu(screen);
            if (action === "recent")
                mainInstance?.openRecentApps();
            else if (action === "auto")
                mainInstance?.keyboardAuto();
            else if (action === "show")
                mainInstance?.keyboardShow();
            else if (action === "hide")
                mainInstance?.keyboardHide();
            else if (action === "disable")
                mainInstance?.keyboardDisable();
            else if (action === "settings")
                BarService.openPluginSettings(root.screen, pluginApi.manifest);
        }
    }
}
