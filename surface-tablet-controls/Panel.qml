import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

Item {
    id: root

    property var pluginApi: null
    readonly property var mainInstance: pluginApi?.mainInstance
    readonly property var geometryPlaceholder: panelContainer
    property real contentPreferredWidth: 360 * Style.uiScaleRatio
    property real contentPreferredHeight: panelContent.implicitHeight + Style.marginL * 2
    readonly property bool allowAttach: true

    anchors.fill: parent

    Rectangle {
        id: panelContainer
        anchors.fill: parent
        color: "transparent"

        ColumnLayout {
            id: panelContent
            anchors.fill: parent
            anchors.margins: Style.marginL
            spacing: Style.marginM

            NText {
                text: "Surface Tablet Controls"
                pointSize: Style.fontSizeL
                font.weight: Font.DemiBold
                color: Color.mOnSurface
            }

            NText {
                text: "Recent apps"
                pointSize: Style.fontSizeM
                color: Color.mOnSurfaceVariant
            }

            NButton {
                Layout.fillWidth: true
                text: "Open qs-hyprview"
                icon: "layout-dashboard"
                onClicked: mainInstance?.openRecentApps()
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Color.mOutline
                opacity: 0.3
            }

            NText {
                text: "Keyboard"
                pointSize: Style.fontSizeM
                color: Color.mOnSurfaceVariant
            }

            NButton {
                Layout.fillWidth: true
                text: "Auto + show now"
                icon: "keyboard-show"
                onClicked: mainInstance?.keyboardAuto()
            }

            NButton {
                Layout.fillWidth: true
                text: "Show"
                icon: "keyboard"
                onClicked: mainInstance?.keyboardShow()
            }

            NButton {
                Layout.fillWidth: true
                text: "Hide"
                icon: "keyboard-hide"
                onClicked: mainInstance?.keyboardHide()
            }

            NButton {
                Layout.fillWidth: true
                text: "Disable"
                icon: "keyboard-off"
                onClicked: mainInstance?.keyboardDisable()
            }

            NText {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                visible: (mainInstance?.lastError ?? "") !== ""
                text: mainInstance?.lastError ?? ""
                color: Color.mError
                pointSize: Style.fontSizeS
            }
        }
    }
}
