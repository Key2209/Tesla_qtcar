import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtGraphicalEffects 1.15
import "Components"
import "qrc:/LayoutManager.js" as Responsive
import QtQuick.Window 2.2

ApplicationWindow {
    id: root
    width: Screen.width
    height: Screen.height
    visibility: Window.FullScreen // 若想以全屏启动，可以取消这行注释
    visible: true
    title: qsTr("Tesla Model 3")
    onWidthChanged: {
        if(adaptive)
            adaptive.updateWindowWidth(root.width)
    }

    onHeightChanged: {
        if(adaptive)
            adaptive.updateWindowHeight(root.height)
    }
    property var adaptive: new Responsive.AdaptiveLayoutManager(root.width,root.height, root.width,root.height)

    FontLoader {
        id: uniTextFont
        source: "qrc:/Fonts/Unitext Regular.ttf"
    }

    // 提供一个背景色的底层
    Rectangle {
        anchors.fill: parent
        color: "#171717"
    }

    // ----------------------------------------
    // 第一个界面: 默认主页 (汽车图片在正中间)
    // ----------------------------------------
    Item {
        id: homeScreen
        width: root.width
        height: root.height
        
        // 汽车处于中间时显示，切换时做淡出和稍微的左移或缩小动画
        opacity: Style.mapAreaVisible ? 0 : 1
        scale: Style.mapAreaVisible ? 0.95 : 1.0
        x: Style.mapAreaVisible ? -80 : 0 
        
        Behavior on opacity {
            NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
        }
        Behavior on scale {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuart }
        }
        Behavior on x {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuart }
        }

        Loader {
            anchors.fill: parent
            sourceComponent: backgroundImage
        }

        // 添加一个全局的右向左滑动检测 (左滑触发进入第二个界面)
        MouseArea {
            anchors.fill: parent
            property int startX: 0
            onPressed: (mouse) => startX = mouse.x
            onReleased: (mouse) => {
                let dx = mouse.x - startX
                // 向左滑动超过100像素 && 不是拖拽点击
                if (dx < -100) {
                    Style.mapAreaVisible = true
                } else if (Math.abs(dx) < 20) {
                    // 如果单纯点击屏幕中央区域，也保持原有的进入动作
                    if (mouse.x > width * 0.3 && mouse.x < width * 0.7 && 
                        mouse.y > height * 0.3 && mouse.y < height * 0.7) {
                        Style.mapAreaVisible = true
                    }
                }
            }
        }
    }

    // ----------------------------------------
    // 第二个界面: (左侧小汽车，右侧模块)
    // ----------------------------------------
    RowLayout {
        id: mapLayout
        spacing: 0
        width: root.width
        height: root.height
        
        // 切换时做淡入并在一定距离内平滑弹入，而不是从整个屏幕外飞进来
        opacity: Style.mapAreaVisible ? 1 : 0
        x: Style.mapAreaVisible ? 0 : 120 
        
        visible: opacity > 0 // 彻底透明时隐藏以节省性能防误触

        Behavior on opacity {
            NumberAnimation { duration: 450; easing.type: Easing.OutCubic }
        }
        Behavior on x {
            NumberAnimation { duration: 500; easing.type: Easing.OutExpo }
        }

        Item {
            Layout.preferredWidth: 620
            Layout.fillHeight: true

            // Image {
            //     anchors.centerIn: parent
            //     source: Style.isDark ? "qrc:/icons/light/sidebar.png" : "qrc:/icons/dark/sidebar-light.png"
            // }
            Image {
                id: sidebarImage
                anchors.centerIn: parent
                
                // 去掉了 Style.isDark，直接根据 gearSelector 的当前索引动态返回图片路径
                source: {
                    switch(gearSelector.currentIndex) {
                        case 0: // P档 (Park)
                            return "qrc:/icons/light/sidebar.png" 
                        case 1: // R档 (Reverse)
                            return "qrc:/icons/light/tsl_r1.png"
                        case 2: // N档 (Neutral)
                            return "qrc:/icons/light/sidebar.png"
                        case 3: // D档 (Drive)
                            return "qrc:/icons/light/tsl_r1.png"
                        default:
                            return "qrc:/icons/light/sidebar.png" // 默认兜底图片
                    }
                }
                
                // 可选：添加一个简单的淡入淡出动画，让图片切换更丝滑
                Behavior on source {
                    // 注意：不同图片间的 source 切换默认是瞬间的。
                    // 如果需要完美的交叉淡入淡出，通常会用两个 Image 组件相互交替透明度，
                    // 但对于简单的应用，直接切换也是可以的。
                }
            }
            
            // 在左边栏添加滑动手势 (右滑返回主界面)
            MouseArea {
                anchors.fill: parent
                property int startX: 0
                onPressed: (mouse) => startX = mouse.x
                onReleased: (mouse) => {
                    let dx = mouse.x - startX
                    // 向右滑动超过80像素
                    if (dx > 80) {
                        Style.mapAreaVisible = false
                    }
                }
            }

            Rectangle {
                id: gearSelector
                width: 380
                height: 54
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 180
                anchors.horizontalCenter: parent.horizontalCenter
                color: Style.isDark ? "#28292C" : "#E2E2E2"
                radius: height / 2

                property var gears: ["P", "R", "N", "D"]
                property int currentIndex: 0

                // DropShadow for active indicator can be enabled if wanted, but simpler flat modern look here
                Rectangle {
                    id: activeInc
                    width: gearSelector.width / gearSelector.gears.length - 8
                    height: gearSelector.height - 8
                    y: 4
                    radius: height / 2
                    color: Style.blueMedium
                    x: gearSelector.currentIndex * (gearSelector.width / gearSelector.gears.length) + 4
                    
                    Behavior on x {
                        NumberAnimation { 
                            duration: 350; 
                            easing.type: Easing.OutBack; 
                            easing.overshoot: 1.2 
                        }
                    }
                }

                Row {
                    anchors.fill: parent
                    Repeater {
                        model: gearSelector.gears
                        Item {
                            width: gearSelector.width / gearSelector.gears.length
                            height: gearSelector.height
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: gearSelector.currentIndex === index ? Style.white : (Style.isDark ? "#818181" : Style.black20)
                                font.pixelSize: 22
                                font.bold: Font.DemiBold
                                font.family: "Inter"
                                
                                Behavior on color {
                                    ColorAnimation { duration: 250 }
                                }
                                
                                // Scale animation when selected
                                scale: gearSelector.currentIndex === index ? 1.1 : 1.0
                                Behavior on scale {
                                    NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: gearSelector.currentIndex = index
                            }
                        }
                    }
                }
            }
        }

        NavigationMapHelperScreen {
            id: rightPanelWidget
            Layout.fillWidth: true
            Layout.fillHeight: true
            runMenuAnimation: true
        }




        
    }

    // ----------------------------------------
    // 始终浮在最上层的公共UI
    // ----------------------------------------
    Header {
        z: 99
        id: headerLayout
    }

    footer: Footer{
        z: 99
        id: footerLayout
        onOpenLauncher: launcher.open()

        // 👉 2. 接收我们在 Footer.qml 里写的信号
        onToggleApp: {
            // 参数 appId: 1=地图, 2=音乐, 3=天气
            
            // 如果当前在主界面（只有车在中间），就先进入带有右侧面板的界面
            if (!Style.mapAreaVisible) {
                Style.mapAreaVisible = true;
                rightPanelWidget.activeWidget = appId;
            } 
            // 如果已经在带有右侧面板的界面了
            else {
                // 如果点的是当前正在全屏的应用，就缩回去变为分屏(0)
                if (rightPanelWidget.activeWidget === appId) {
                    rightPanelWidget.activeWidget = 0;
                } 
                // 否则就全屏打开对应的应用
                else {
                    rightPanelWidget.activeWidget = appId;
                }
            }
        }
    }

    TopLeftButtonIconColumn {
        z: 99
        anchors.left: parent.left
        anchors.top: headerLayout.bottom
        anchors.leftMargin: 18
    }

    LaunchPadControl {
        id: launcher
        z: 99
        y: (root.height - height) / 2 + (footerLayout.height)
        x: (root.width - width ) / 2
    }

    Component {
        id: backgroundImage
        Image {
            source: Style.getImageBasedOnTheme()
            Icon {
                icon.source: Style.isDark ? "qrc:/icons/car_action_icons/dark/lock.svg" : "qrc:/icons/car_action_icons/lock.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: - 350
                anchors.horizontalCenterOffset: 37
            }

            Icon {
                icon.source: Style.isDark ? "qrc:/icons/car_action_icons/dark/Power.svg" : "qrc:/icons/car_action_icons/Power.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: - 77
                anchors.horizontalCenterOffset: 550
            }

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: - 230
                anchors.horizontalCenterOffset: 440

                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    text: "Trunk"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.bold: Font.DemiBold
                    color: Style.black20
                }
                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    text: "Open"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.bold: Font.Bold
                    color: Style.isDark ? Style.white : "#171717"
                }
            }

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: - 180
                anchors.horizontalCenterOffset: - 350

                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    text: "Frunk"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.bold: Font.DemiBold
                    color: Style.black20
                }
                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    text: "Open"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.bold: Font.Bold
                    color: Style.isDark ? Style.white : "#171717"
                }
            }
        }
    }
}
