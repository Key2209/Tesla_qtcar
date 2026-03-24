import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle {
    id: rootApp
    color: "#1C1C1E"; radius: 16; border.color: "#38383A"; border.width: 1; clip: true
    signal requestClose()
    MouseArea { anchors.fill: parent }

    property int currentClipIndex: 0
    property bool isVideoPlaying: false

    RowLayout {
        anchors.fill: parent; anchors.margins: 30; spacing: 30
        
        // 左侧：视频播放主控区
        ColumnLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 15
            Text { text: "Dashcam Viewer"; color: "white"; font.pixelSize: 28; font.weight: Font.Bold }

            Rectangle {
                Layout.fillWidth: true; Layout.fillHeight: true; radius: 12; color: "black"; clip: true
                
                // 模拟视频画面 (联动右侧列表的数据)
                Image {
                    source: clipModel.get(currentClipIndex).thumb
                    anchors.fill: parent; fillMode: Image.PreserveAspectCrop; opacity: isVideoPlaying ? 1.0 : 0.6
                    Behavior on opacity { NumberAnimation { duration: 300 } }
                }
                
                // 大播放按钮
                Rectangle {
                    width: 80; height: 80; radius: 40; color: "#80000000"; border.color: "white"; border.width: 2; anchors.centerIn: parent
                    visible: !isVideoPlaying
                    Text { text: "▶"; color: "white"; font.pixelSize: 36; anchors.centerIn: parent; anchors.horizontalCenterOffset: 4 }
                    MouseArea { anchors.fill: parent; onClicked: isVideoPlaying = true }
                }

                // 底部进度控制条
                Rectangle {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
                    height: 50; color: "#A0000000"
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 15; spacing: 15
                        Text { 
                            text: isVideoPlaying ? "⏸" : "▶"; color: "white"; font.pixelSize: 18 
                            MouseArea { anchors.fill: parent; onClicked: isVideoPlaying = !isVideoPlaying }
                        }
                        Slider {
                            Layout.fillWidth: true; value: 0.2
                            background: Rectangle { y: parent.height/2-2; width: parent.width; height: 4; radius: 2; color: "#555"; Rectangle { width: parent.parent.visualPosition * parent.width; height: parent.height; color: "#FF3B30"; radius: 2 } }
                            handle: Rectangle { x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width); y: parent.topPadding + parent.availableHeight / 2 - height / 2; width: 14; height: 14; radius: 7; color: "white" }
                        }
                        Text { text: clipModel.get(currentClipIndex).timeStr; color: "white"; font.pixelSize: 14 }
                    }
                }
            }
        }

        // 右侧：录像切片画廊
        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.35; Layout.fillHeight: true; spacing: 15
            Text { text: "Recent Clips"; color: "white"; font.pixelSize: 20; font.weight: Font.Bold; Layout.topMargin: 10 }
            
            ListModel {
                id: clipModel
                ListElement { date: "Today 08:30 AM"; loc: "Highway 101"; thumb: "qrc:/icons/dashcam_placeholder.jpg"; timeStr: "-03:20" }
                ListElement { date: "Yesterday 06:15 PM"; loc: "Parking Lot"; thumb: "qrc:/icons/movie_placeholder.jpg"; timeStr: "-01:10" }
            }

            ListView {
                Layout.fillWidth: true; Layout.fillHeight: true; clip: true; spacing: 15; model: clipModel
                delegate: Rectangle {
                    width: parent.width; height: 100; radius: 10
                    color: currentClipIndex === index ? "#3A3A3C" : "#2C2C2E"
                    border.color: currentClipIndex === index ? "#FF3B30" : "transparent"; border.width: 2 // 选中的视频带红框
                    
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 15
                        // 缩略图
                        Rectangle {
                            width: 120; height: 80; radius: 6; color: "black"; clip: true
                            Image { source: thumb; anchors.fill: parent; fillMode: Image.PreserveAspectCrop }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true; spacing: 4
                            Text { text: date; color: "white"; font.pixelSize: 14; font.weight: Font.Bold }
                            Text { text: loc; color: "#8E8E93"; font.pixelSize: 12 }
                        }
                    }
                    MouseArea { 
                        anchors.fill: parent
                        // 点击列表切换视频源，并重置播放状态
                        onClicked: { currentClipIndex = index; isVideoPlaying = false } 
                    }
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