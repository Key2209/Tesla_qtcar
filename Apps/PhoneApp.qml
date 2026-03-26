import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle {
    id: rootApp
    color: "#1C1C1E"; radius: 16; border.color: "#38383A"; border.width: 1; clip: true
    signal requestClose()
    MouseArea { anchors.fill: parent }

    property string dialNumber: "" // 存储用户输入的号码

    RowLayout {
        anchors.fill: parent; anchors.margins: 40; spacing: 60

        // 最近通话
        ColumnLayout {
            Layout.fillHeight: true; Layout.preferredWidth: parent.width * 0.4; spacing: 20
            Text { text: "Recents"; color: "white"; font.pixelSize: 32; font.weight: Font.Bold }
            ListView {
                Layout.fillWidth: true; Layout.fillHeight: true; clip: true; spacing: 15
                model: ListModel {
                    ListElement { name: "Elon Musk"; type: "Mobile"; time: "10:42 AM"; missed: false }
                    ListElement { name: "Tim Cook"; type: "Work"; time: "Yesterday"; missed: true }
                }
                delegate: RowLayout {
                    width: parent.width; height: 50
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 4
                        Text { text: name; color: missed ? "#FF3B30" : "white"; font.pixelSize: 20; font.weight: Font.Medium }
                        Text { text: type; color: "#8E8E93"; font.pixelSize: 14 }
                    }
                    Text { text: time; color: "#8E8E93"; font.pixelSize: 16 }
                    Text { text: "ⓘ"; color: "#0A84FF"; font.pixelSize: 24; Layout.leftMargin: 15 }
                }
            }
        }

        // 拨号盘
        ColumnLayout {
            Layout.fillHeight: true; Layout.fillWidth: true; spacing: 20
            
            // 显示号码框 (如果为空则提示)
            Text { 
                text: dialNumber === "" ? "Enter Number" : dialNumber
                color: dialNumber === "" ? "#555" : "white"; font.pixelSize: 40; font.weight: Font.Light
                Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 20
                Layout.preferredHeight: 50
            }

            GridLayout {
                columns: 3; columnSpacing: 30; rowSpacing: 20; Layout.alignment: Qt.AlignHCenter
                Repeater {
                    model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
                    delegate: Rectangle {
                        width: 80; height: 80; radius: 40; color: numMouse.pressed ? "#555555" : "#2C2C2E"
                        Text { text: modelData; color: "white"; font.pixelSize: 36; font.weight: Font.Light; anchors.centerIn: parent }
                        MouseArea { 
                            id: numMouse; anchors.fill: parent
                            onClicked: dialNumber += modelData // 拼接号码
                        }
                    }
                }
            }

            // 底部操作区：拨打和退格
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 40
                Item { width: 40; height: 40 } // 左侧占位平衡
                
                Rectangle {
                    width: 80; height: 80; radius: 40; color: callMouse.pressed ? "#248A3D" : "#34C759"
                    Text { text: "📞"; color: "white"; font.pixelSize: 36; anchors.centerIn: parent }
                    MouseArea { id: callMouse; anchors.fill: parent; onClicked: console.log("Calling: " + dialNumber) }
                }
                
                // 退格键 (仅在有号码时显示)
                Text {
                    text: "⌫"; color: "#8E8E93"; font.pixelSize: 32
                    visible: dialNumber.length > 0; Layout.alignment: Qt.AlignVCenter
                    MouseArea { anchors.fill: parent; onClicked: dialNumber = dialNumber.substring(0, dialNumber.length - 1) }
                }
            }
        }
    }
    
    Rectangle {
        width: 36; height: 36; radius: 18; color: "#3A3A3C"; anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 20
        Text { text: "✕"; color: "#8E8E93"; font.pixelSize: 16; anchors.centerIn: parent }
        MouseArea { anchors.fill: parent; onClicked: rootApp.requestClose() }
    }
}