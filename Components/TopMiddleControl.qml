import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0

RowLayout {
    spacing: 30

    // 1. 解锁图标
    Icon {
        Layout.alignment: Qt.AlignVCenter
        icon.source: Style.isDark ? "qrc:/icons/top_header_icons/dark/lock.svg" : "qrc:/icons/top_header_icons/lock.svg"
        onClicked: Style.mapAreaVisible = !Style.mapAreaVisible
    }

    // 2. 用户图标 + 名称
    RowLayout {
        Layout.alignment: Qt.AlignVCenter
        spacing: 8
        Image {
            Layout.alignment: Qt.AlignVCenter
            sourceSize: Qt.size(40, 40)
            source: Style.isDark ? "qrc:/icons/top_header_icons/dark/icons.svg" : "qrc:/icons/top_header_icons/icons.svg"
        }
        Text {
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 18
            font.weight: Font.DemiBold
            font.family: "Inter"
            color: Style.isDark ? Style.white : Style.black20
            text: qsTr("蔡徐坤")
        }
    }

    // 3. 行车记录仪 (Dashcam)
    Item {
        Layout.alignment: Qt.AlignVCenter
        width: 20; height: 20
        Rectangle {
            anchors.centerIn: parent
            width: 20; height: 20
            radius: 10
            color: "transparent"
            border.color: Style.isDark ? Style.white : Style.black20
            border.width: 1.5
            Rectangle {
                anchors.centerIn: parent
                width: 8; height: 8
                radius: 4
                color: "#E23C3C"
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: Style.isDark = !Style.isDark 
        }
    }

    // 4. SOS
    RowLayout {
        Layout.alignment: Qt.AlignVCenter
        spacing: 2
        Text {
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 18
            font.weight: Font.DemiBold
            font.family: "Inter"
            color: Style.isDark ? Style.white : Style.black20
            text: "SOS"
        }
        Text {
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 14
            color: Style.isDark ? Style.white : Style.black20
            text: "📞" 
        }
    }

    // 5. 时间
    Text {
        id: timeText
        Layout.alignment: Qt.AlignVCenter
        font.pixelSize: 20
        font.weight: Font.DemiBold
        font.family: "Inter"
        color: Style.isDark ? Style.white : Style.black20
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: timeText.text = Qt.formatTime(new Date(), "hh:mm")
        }
    }

    // 6. 天气 + AQI
    ColumnLayout {
        Layout.alignment: Qt.AlignVCenter
        spacing: 2

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6
            Text {
                font.pixelSize: 18
                text: "⛅"
            }
            Text {
                font.pixelSize: 18
                font.weight: Font.DemiBold
                font.family: "Inter"
                color: Style.isDark ? Style.white : Style.black20
                text: "40°"
            }
        }
        
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 48; height: 18
            radius: 4
            color: "#27B34A"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 11
                font.weight: Font.DemiBold
                font.family: "Inter"
                color: "white"
                text: "AQI 42"
            }
        }
    }
}
