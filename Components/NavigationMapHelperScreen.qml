import QtQuick 2.9
import QtLocation 5.6
import QtQml 2.3
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtPositioning 5.6
import QtQuick.Layouts 1.3
import Style 1.0
import "../Apps"

import QtQuick 2.9
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

// import Style 1.0
import "../Apps"

Rectangle {
    id: rightPanelContainer
    property bool runMenuAnimation: false
    color: "transparent"
    visible: true
    clip: true

    property int activeWidget: 0

    property int paddingVal: 20
    property int cardSpacing: 20
    property int bottomWidgetHeight: 180
    property int topSafeMargin: 50
    property int bottomSafeMargin: 120

    property color cardBackgroundColor: "#1C1C1E"
    property color cardBorderColor: "#38383A"
    property color themeColor: "#FA114F" // Apple Music 标志性粉红



    // ----------------------
    // 1. 地图模块 (保持不变)
    // ----------------------
    Rectangle {
        id: mapWidgetContainer
        color: cardBackgroundColor
        radius: 16
        border.color: cardBorderColor
        border.width: 1
        clip: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: topSafeMargin + paddingVal
        anchors.leftMargin: paddingVal
        anchors.rightMargin: paddingVal
        height: activeWidget === 1 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2 - cardSpacing - bottomWidgetHeight)
        opacity: activeWidget === 0 || activeWidget === 1 ? 1 : 0
        visible: opacity > 0
        z: activeWidget === 1 ? 99 : 1
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

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: activeWidget = activeWidget === 0 ? 1 : 0
        }

        Rectangle {
            z: 100
            width: 44
            height: 44
            radius: 22
            color: "#80000000"
            border.color: "#40FFFFFF"
            border.width: 1
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            Text {
                text: activeWidget === 0 ? "↙" : "↗"
                font.pixelSize: 18
                color: "white"
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                onClicked: activeWidget = activeWidget === 0 ? 1 : 0
                onPressed: parent.opacity = 0.6
                onReleased: parent.opacity = 1.0
            }
        }
    }    // ----------------------
    // 2. 音乐模块
    // ----------------------
    MusicApp {
        id: musicWidgetContainer
        activeWidget: rightPanelContainer.activeWidget
        paddingVal: rightPanelContainer.paddingVal
        cardSpacing: rightPanelContainer.cardSpacing
        bottomWidgetHeight: rightPanelContainer.bottomWidgetHeight
        topSafeMargin: rightPanelContainer.topSafeMargin
        bottomSafeMargin: rightPanelContainer.bottomSafeMargin
        cardBackgroundColor: rightPanelContainer.cardBackgroundColor
        cardBorderColor: rightPanelContainer.cardBorderColor
        themeColor: rightPanelContainer.themeColor

        onRequestToggleActive: rightPanelContainer.activeWidget = rightPanelContainer.activeWidget === 0 ? 2 : 0
    }    // ----------------------
    // 3. 天气模块
    // ----------------------
    WeatherApp {
        id: weatherWidgetContainer
        activeWidget: rightPanelContainer.activeWidget
        paddingVal: rightPanelContainer.paddingVal
        cardSpacing: rightPanelContainer.cardSpacing
        bottomWidgetHeight: rightPanelContainer.bottomWidgetHeight
        topSafeMargin: rightPanelContainer.topSafeMargin
        bottomSafeMargin: rightPanelContainer.bottomSafeMargin
        cardBackgroundColor: rightPanelContainer.cardBackgroundColor
        cardBorderColor: rightPanelContainer.cardBorderColor
        themeColor: rightPanelContainer.themeColor

        onRequestToggleActive: rightPanelContainer.activeWidget = rightPanelContainer.activeWidget === 0 ? 3 : 0
    }




// ==========================================
    // 🌟 全屏应用动态加载器 (核心魔法)
    // ==========================================
    Loader {
        id: dynamicAppLoader
        z: 99 // 保证加载出来的App盖在最上面
        
        // 占据整个右侧操作区，预留安全边距
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: topSafeMargin + paddingVal
        anchors.bottomMargin: bottomSafeMargin + paddingVal
        anchors.leftMargin: paddingVal
        anchors.rightMargin: paddingVal

        // 【内存控制】：只有点击了这四个应用时，才激活加载！
        // 4=电话, 6=蓝牙, 7=记录仪
        active: activeWidget === 4 || activeWidget === 6 || activeWidget === 7

        // 【路径配置】：根据 activeWidget 动态返回对应的文件路径
        // 注意：如果你使用了 Qt 资源文件(qrc)，路径前面通常需要加 "qrc:/"
        source: {
            switch(activeWidget) {
                case 4: return "qrc:/Apps/PhoneApp.qml"
                case 6: return "qrc:/Apps/BluetoothApp.qml"
                case 7: return "qrc:/Apps/DashcamApp.qml"
                default: return ""
            }
        }

        // 【丝滑动画】：App 加载完成后，做一个 300ms 的淡入效果
        opacity: status === Loader.Ready ? 1 : 0
        Behavior on opacity { 
            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } 
        }

        // 【信号连接】：监听被加载的独立 App 内部发出的退出信号
        Connections {
            // target 指向 Loader 内部实际加载出来的那个 QML 根节点
            target: dynamicAppLoader.item 
            
            // 忽略由于 Loader 尚未加载完成或切换瞬间导致的未知信号报错
            ignoreUnknownSignals: true 

            // 当内部 App 调用 rootApp.requestClose() 时，这里就会收到信号
            onRequestClose: {
                // 收到关闭信号，把状态改回 0 (分屏主页)
                // 这时 active 会变成 false，刚才的 App 就会被彻底从内存中销毁！
                activeWidget = 0; 
            }
        }
    }
}
