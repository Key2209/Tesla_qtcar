import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle {
    id: rootApp
    color: "#1C1C1E"; radius: 16; border.color: "#38383A"; border.width: 1; clip: true
    signal requestClose()
    MouseArea { anchors.fill: parent }

    property bool btEnabled: true // 全局蓝牙开关状态

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 40; spacing: 30
        
        Text { text: "Bluetooth Settings"; color: "white"; font.pixelSize: 36; font.weight: Font.Bold; Layout.bottomMargin: 20 }

        // 主开关
        Rectangle {
            Layout.fillWidth: true; height: 80; radius: 16; color: "#2C2C2E"
            RowLayout {
                anchors.fill: parent; anchors.margins: 20
                Text { text: "Bluetooth"; color: "white"; font.pixelSize: 22; Layout.fillWidth: true }
                
                // 动态 Switch
                Rectangle {
                    width: 60; height: 32; radius: 16
                    color: btEnabled ? "#34C759" : "#3A3A3C"
                    Behavior on color { ColorAnimation { duration: 200 } }
                    
                    Rectangle { 
                        width: 28; height: 28; radius: 14; color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        // 核心动画逻辑：开启靠右，关闭靠左
                        x: btEnabled ? parent.width - width - 2 : 2
                        Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
                    }
                    MouseArea { anchors.fill: parent; onClicked: btEnabled = !btEnabled }
                }
            }
        }

        Text { text: "MY DEVICES"; color: "#8E8E93"; font.pixelSize: 14; Layout.topMargin: 20; Layout.leftMargin: 20; visible: btEnabled }

        // 设备列表 (仅在蓝牙开启时可见)
        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true; radius: 16; color: "#2C2C2E"; clip: true; visible: btEnabled
            
            ListModel {
                id: deviceModel
                ListElement { devName: "iPhone 14 Pro"; isConnected: true }
                ListElement { devName: "AirPods Max"; isConnected: false }
            }

            ListView {
                anchors.fill: parent; clip: true
                model: deviceModel
                delegate: Rectangle {
                    width: parent.width; height: 70; color: devMouse.pressed ? "#3A3A3C" : "transparent"
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 20; anchors.rightMargin: 20
                        Text { text: devName; color: "white"; font.pixelSize: 20; Layout.fillWidth: true }
                        Text { text: isConnected ? "Connected" : "Not Connected"; color: isConnected ? "#0A84FF" : "#8E8E93"; font.pixelSize: 18 }
                        Text { text: "ⓘ"; color: "#0A84FF"; font.pixelSize: 24; Layout.leftMargin: 10 }
                    }
                    Rectangle { width: parent.width - 40; height: 1; color: "#3A3A3C"; anchors.bottom: parent.bottom; anchors.right: parent.right }
                    MouseArea { 
                        id: devMouse; anchors.fill: parent
                        // 点击切换连接状态
                        onClicked: deviceModel.setProperty(index, "isConnected", !isConnected) 
                    }
                }
            }
        }
        Item { Layout.fillHeight: true; visible: !btEnabled } // 蓝牙关闭时的占位防塌陷
    }
    
    Rectangle {
        width: 36; height: 36; radius: 18; color: "#3A3A3C"; anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 20
        Text { text: "✕"; color: "#8E8E93"; font.pixelSize: 16; anchors.centerIn: parent }
        MouseArea { anchors.fill: parent; onClicked: rootApp.requestClose() }
    }
}