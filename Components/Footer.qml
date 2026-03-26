// import QtQuick 2.9
// import QtQuick.Controls 2.5
// import QtQuick.Layouts 1.3
// import Style 1.0
// import QtGraphicalEffects 1.15

// Item {
//     height: 120
//     width: parent.width
//     signal openLauncher()
//     LinearGradient {
//         anchors.fill: parent
//         start: Qt.point(0, 0)
//         end: Qt.point(0, 1000)
//         gradient: Gradient {
//             GradientStop { position: 0.0; color: Style.black }
//             GradientStop { position: 1.0; color: Style.black60 }
//         }
//     }

//     Icon{
//         id: leftControl
//         icon.source: "qrc:/icons/app_icons/model-3.svg"
//         anchors.verticalCenter: parent.verticalCenter
//         anchors.left: parent.left
//         anchors.leftMargin: 36
//         onClicked: openLauncher()
//     }

//     Item {
//         height: parent.height
//         anchors.left: leftControl.right
//         anchors.right: middleLayout.left
//         anchors.verticalCenter: parent.verticalCenter

//         StepperControl {
//             anchors.centerIn: parent
//             value: 72
//         }
//     }

//     RowLayout {
//         id: middleLayout
//         anchors.centerIn: parent
//         spacing: 20

//         Icon{
//             icon.source: "qrc:/icons/app_icons/phone.svg"
//         }

//         Icon{
//             icon.source: "qrc:/icons/app_icons/radio.svg"
//         }

//         Icon{
//             icon.source: "qrc:/icons/app_icons/bluetooth.svg"
//         }

//         Icon{
//             icon.source: "qrc:/icons/app_icons/spotify.svg"
//         }

//         Icon{
//             icon.source: "qrc:/icons/app_icons/dashcam.svg"
//         }

//         Icon{
//             icon.source: "qrc:/icons/app_icons/video.svg"
//         }

//         Icon{
//             icon.source: "qrc:/icons/app_icons/tunein.svg"
//         }
//     }

//     Item {
//         height: parent.height
//         anchors.right: rightControl.left
//         anchors.left: middleLayout.right
//         anchors.verticalCenter: parent.verticalCenter

//         StepperControl {
//             anchors.centerIn: parent
//             value: 72
//         }
//     }

//     StepperControl {
//         id: rightControl
//         anchors.verticalCenter: parent.verticalCenter
//         anchors.right: parent.right
//         anchors.rightMargin: 36
//         value: 72
//         icon: "qrc:/icons/app_icons/volume.svg"
//     }
// }

import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtGraphicalEffects 1.15

Item {
    height: 120
    width: parent.width

    // 原有的信号
    signal openLauncher

    // 👇 新增一个专门用来切换上方卡片状态的信号
    // appId 对应：1=地图, 2=音乐, 3=天气
    signal toggleApp(int appId)

    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(0, 1000)
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Style.black
            }
            GradientStop {
                position: 1.0
                color: Style.black60
            }
        }
    }

    Icon {
        id: leftControl
        icon.source: "qrc:/icons/app_icons/model-3.svg"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 36
        onClicked: openLauncher()
    }

    Item {
        height: parent.height
        anchors.left: leftControl.right
        anchors.right: middleLayout.left
        anchors.verticalCenter: parent.verticalCenter

        StepperControl {
            anchors.centerIn: parent
            value: 72
        }
    }

    RowLayout {
        id: middleLayout
        anchors.centerIn: parent
        spacing: 20

        Icon {
            icon.source: "qrc:/icons/app_icons/phone.svg"
            onClicked: toggleApp(4)
        }
        Icon {
            icon.source: "qrc:/icons/app_icons/radio.svg"
            onClicked: toggleApp(5)
        }
        Icon {
            icon.source: "qrc:/icons/app_icons/bluetooth.svg"
            onClicked: toggleApp(6)
        }
        Icon {
            icon.source: "qrc:/icons/app_icons/spotify.svg"
            onClicked: toggleApp(2)
        } // 音乐
        Icon {
            icon.source: "qrc:/icons/app_icons/dashcam.svg"
            onClicked: toggleApp(7)
        }
        Icon {
            icon.source: "qrc:/icons/app_icons/video.svg"
            onClicked: toggleApp(8)
        }
        Icon {
            icon.source: "qrc:/icons/app_icons/tunein.svg"
            onClicked: toggleApp(9)
        }
    }

    Item {
        height: parent.height
        anchors.right: rightControl.left
        anchors.left: middleLayout.right
        anchors.verticalCenter: parent.verticalCenter

        StepperControl {
            anchors.centerIn: parent
            value: 72
        }
    }

    StepperControl {
        id: rightControl
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 36
        value: 72
        icon: "qrc:/icons/app_icons/volume.svg"
    }
}
