// aster — Observatory (SDDM, Qt 6)
import QtQuick

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#0a0a0b"

    readonly property color cSurface: "#111113"
    readonly property color cRule: "#2a2620"
    readonly property color cRing: "#1c1a16"
    readonly property color cText: "#e9e2d3"
    readonly property color cMuted: "#9a917f"
    readonly property color cBrass: "#d4a24c"
    readonly property color cAlert: "#c8735a"
    readonly property string fMono: "IBM Plex Mono"
    readonly property var roman: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"]

    property int sessionIndex: sessionModel.lastIndex
    property date now: new Date()
    property bool failed: false

    function doLogin() {
        root.failed = false
        sddm.login(userField.text, passField.text, root.sessionIndex)
    }

    function sessionName() {
        var item = sessionList.itemAt(root.sessionIndex)
        return item ? item.sessionName.toLowerCase() : ""
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            root.failed = true
            passField.text = ""
            passField.focusInput()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Repeater {
        id: sessionList
        model: sessionModel
        delegate: Item {
            required property string name
            property string sessionName: name
        }
    }

    // Reusable pieces. They carry their own colors (inline components don't
    // see this file's ids).

    component Field: Column {
        id: field
        property alias caption: cap.text
        property alias text: inputItem.text
        property bool secret: false
        readonly property bool hot: inputItem.activeFocus
        signal accepted()
        signal tabbed()
        function focusInput() { inputItem.forceActiveFocus() }

        spacing: 8
        Text {
            id: cap
            color: "#9a917f"
            font.family: "IBM Plex Mono"
            font.pixelSize: 12
            font.letterSpacing: 3
        }
        Rectangle {
            width: field.width
            height: 46
            color: "#0a0a0b"
            border.width: 1
            border.color: field.hot ? "#d4a24c" : "#2a2620"
            TextInput {
                id: inputItem
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                verticalAlignment: TextInput.AlignVCenter
                echoMode: field.secret ? TextInput.Password : TextInput.Normal
                passwordCharacter: "•"
                color: field.secret ? "#d4a24c" : "#e9e2d3"
                font.family: "IBM Plex Mono"
                font.pixelSize: 17
                clip: true
                selectByMouse: true
                onAccepted: field.accepted()
                Keys.onTabPressed: field.tabbed()
            }
        }
    }

    component BarButton: Rectangle {
        id: bb
        property alias label: bbText.text
        signal clicked()
        width: bbText.implicitWidth + 36
        color: bbArea.containsMouse ? "#1e1a12" : "transparent"
        Rectangle { width: 1; height: bb.height; color: "#2a2620" }
        Text {
            id: bbText
            anchors.centerIn: parent
            color: bbArea.containsMouse ? "#d4a24c" : "#e9e2d3"
            font.family: "IBM Plex Mono"
            font.pixelSize: 14
            font.letterSpacing: 2
        }
        MouseArea {
            id: bbArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: bb.clicked()
        }
    }

    // ---------- Orbit rings and crosshair ----------

    readonly property real targetX: root.width * 0.765
    readonly property real targetY: root.height * 0.5

    Repeater {
        model: [0.86, 0.6, 0.33]
        Rectangle {
            required property real modelData
            width: root.width * modelData
            height: width
            radius: width / 2
            x: root.targetX - width / 2
            y: root.targetY - height / 2
            color: "transparent"
            border.color: root.cRing
            border.width: 1
        }
    }
    Rectangle { x: root.targetX; y: 0; width: 1; height: root.height; color: "#16140f" }
    Rectangle { x: root.width * 0.31; y: root.targetY; width: root.width * 0.69; height: 1; color: "#16140f" }
    Rectangle {
        width: 13; height: 13; radius: 6.5
        x: root.targetX - 6; y: root.targetY - 6
        color: root.cBrass
    }

    // ---------- Clock ----------

    Column {
        x: 96
        y: 96
        spacing: 10

        Row {
            Text {
                id: clockText
                text: Qt.formatDateTime(root.now, "HH:mm")
                color: root.cText
                font.family: root.fMono
                font.pixelSize: 120
                font.weight: Font.Medium
            }
            Text {
                anchors.baseline: clockText.baseline
                text: Qt.formatDateTime(root.now, ":ss")
                color: root.cBrass
                font.family: root.fMono
                font.pixelSize: 42
            }
        }
        Text {
            text: Qt.formatDateTime(root.now, "ddd").toUpperCase() + " · "
                  + Qt.formatDateTime(root.now, "dd") + " · "
                  + root.roman[root.now.getMonth()] + " · "
                  + Qt.formatDateTime(root.now, "yyyy")
            color: root.cMuted
            font.family: root.fMono
            font.pixelSize: 18
            font.letterSpacing: 4
        }
    }

    // ---------- Console ----------

    Rectangle {
        x: 96
        y: root.height * 0.42
        width: 500
        height: consoleCol.implicitHeight
        color: root.cSurface
        border.color: root.failed ? root.cAlert : root.cBrass
        border.width: 1

        Column {
            id: consoleCol
            width: parent.width

            // Header: ASTER tab · LOGIN
            Item {
                width: parent.width
                height: 36
                Rectangle {
                    x: 1; y: 1
                    width: asterLabel.implicitWidth + 32
                    height: parent.height - 1
                    color: root.cBrass
                    Text {
                        id: asterLabel
                        anchors.centerIn: parent
                        text: "ASTER"
                        color: root.cSurface
                        font.family: root.fMono
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                        font.letterSpacing: 3
                    }
                }
                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.failed ? "DENIED" : "LOGIN"
                    color: root.failed ? root.cAlert : root.cMuted
                    font.family: root.fMono
                    font.pixelSize: 13
                    font.letterSpacing: 3
                }
                Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: root.cRule }
            }

            Item {
                width: parent.width
                height: fields.implicitHeight + 44
                Column {
                    id: fields
                    x: 18
                    y: 22
                    width: parent.width - 36
                    spacing: 18

                    Field {
                        id: userField
                        width: parent.width
                        caption: "USER"
                        text: userModel.lastUser
                        onAccepted: passField.focusInput()
                        onTabbed: passField.focusInput()
                    }
                    Field {
                        id: passField
                        width: parent.width
                        caption: "PASSWORD"
                        secret: true
                        onAccepted: root.doLogin()
                        onTabbed: userField.focusInput()
                        Component.onCompleted: focusInput()
                    }
                }
            }

            // Footer: SESSION hyprland · ENTER ›
            Item {
                width: parent.width
                height: 48
                Rectangle { width: parent.width; height: 1; color: root.cRule }
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 18
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "SESSION"
                        color: root.cMuted
                        font.family: root.fMono
                        font.pixelSize: 12
                        font.letterSpacing: 3
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: (sessionList.count > 0 ? root.sessionName() : "—") + " ↻"
                        color: sessionArea.containsMouse ? root.cBrass : root.cText
                        font.family: root.fMono
                        font.pixelSize: 15
                        MouseArea {
                            id: sessionArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.sessionIndex = (root.sessionIndex + 1) % Math.max(1, sessionModel.count)
                        }
                    }
                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.rightMargin: 1
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    height: parent.height - 2
                    width: enterLabel.implicitWidth + 40
                    color: enterArea.containsMouse ? "#f0c472" : root.cBrass
                    Text {
                        id: enterLabel
                        anchors.centerIn: parent
                        text: "ENTER ›"
                        color: root.cSurface
                        font.family: root.fMono
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        font.letterSpacing: 3
                    }
                    MouseArea {
                        id: enterArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.doLogin()
                    }
                }
            }
        }
    }

    // ---------- Bottom bar ----------

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 40
        color: root.cSurface
        Rectangle { width: parent.width; height: 1; color: root.cRule }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            text: sddm.hostName + " · nixos"
            color: root.cMuted
            font.family: root.fMono
            font.pixelSize: 14
        }

        Row {
            anchors.right: parent.right
            height: parent.height
            BarButton { height: parent.height; label: "RESTART"; visible: sddm.canReboot; onClicked: sddm.reboot() }
            BarButton { height: parent.height; label: "SHUTDOWN"; visible: sddm.canPowerOff; onClicked: sddm.powerOff() }
        }
    }
}
