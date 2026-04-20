import QtQuick
import qs.Common
import qs.Widgets

Rectangle {
    id: root

    property string iconName: ""
    property color iconColor: Theme.surfaceText
    property int buttonSize: 36
    signal clicked

    width: buttonSize
    height: buttonSize
    radius: Math.round(buttonSize / 2)
    color: mouseArea.containsMouse ? Theme.surfaceContainerHighest : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Theme.shorterDuration
            easing.type: Theme.standardEasing
        }
    }

    DankIcon {
        anchors.centerIn: parent
        name: root.iconName
        size: Math.max(16, root.buttonSize - Theme.spacingL)
        color: root.iconColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
