import QtQuick 2.9
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQml 2.3
import Style 1.0


    // 3. 天气模块 (保持不变)
    // ----------------------
    Rectangle {

    property int activeWidget: 0
    property int paddingVal: 20
    property int cardSpacing: 20
    property int bottomWidgetHeight: 180
    property int topSafeMargin: 50
    property int bottomSafeMargin: 120
    property color cardBackgroundColor: "#1C1C1E"
    property color cardBorderColor: "#38383A"
    property color themeColor: "#FA114F"
    
    signal requestToggleActive()



    // 天气接口预留
    property string weatherCity: "Cupertino"
    property string weatherDate: "Tuesday, March 24"
    property string weatherTemp: "22°"
    property string weatherCondition: "Partly Cloudy"
    property string weatherHighLow: "H:26° L:14°"
    property string weatherIconPath: "qrc:/icons/weather_cloud.png"
        id: weatherWidgetContainer
        radius: 16
        clip: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottomSafeMargin + paddingVal
        anchors.rightMargin: paddingVal
        anchors.leftMargin: activeWidget === 3 ? paddingVal : (parent.width / 2 + cardSpacing / 2)
        height: activeWidget === 3 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : bottomWidgetHeight
        opacity: activeWidget === 0 || activeWidget === 3 ? 1 : 0
        visible: opacity > 0
        z: activeWidget === 3 ? 99 : 1
        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuart
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuart
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(parent.width, parent.height)
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#2E335A"
                }
                GradientStop {
                    position: 1.0
                    color: "#1C1B33"
                }
            }
        }
        Rectangle {
            anchors.fill: parent
            radius: 16
            color: "transparent"
            border.color: "#40FFFFFF"
            border.width: 1
        }

        MouseArea {
            anchors.fill: parent
            onClicked: requestToggleActive()
        }

        Item {
            anchors.fill: parent
            anchors.margins: 24
            ColumnLayout {
                anchors.top: parent.top
                anchors.left: parent.left
                spacing: 4
                Text {
                    text: weatherCity
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: "white"
                }
                Text {
                    text: weatherDate
                    font.pixelSize: 14
                    color: "#EBEBF5"
                    opacity: 0.6
                }
            }
            Item {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: activeWidget === 3 ? 40 : 10
                width: activeWidget === 3 ? 160 : 80
                height: width
                Behavior on width {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutBack
                    }
                }
                Image {
                    source: weatherIconPath
                    anchors.centerIn: parent
                    width: parent.width * 0.8
                    height: width
                    fillMode: Image.PreserveAspectFit
                    visible: status === Image.Ready
                }
                Text {
                    text: "⛅"
                    font.pixelSize: parent.width * 0.8
                    anchors.centerIn: parent
                    visible: !parent.children[0].visible
                }
            }
            ColumnLayout {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                spacing: -4
                Text {
                    text: weatherTemp
                    font.pixelSize: activeWidget === 3 ? 96 : 64
                    font.weight: Font.Light
                    color: "white"
                    Behavior on font.pixelSize {
                        NumberAnimation {
                            duration: 400
                            easing.type: Easing.InOutQuart
                        }
                    }
                }
                Text {
                    text: weatherCondition + " • " + weatherHighLow
                    font.pixelSize: 16
                    color: "#EBEBF5"
                    opacity: 0.6
                }
            }
        }
    }