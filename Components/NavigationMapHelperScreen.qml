// import QtQuick 2.9
// import QtLocation 5.6
// import QtQml 2.3
// import QtQuick.Controls 2.5
// import QtGraphicalEffects 1.0
// import QtPositioning 5.6
// import QtQuick.Layouts 1.3
// import Style 1.0

// Rectangle {
//     id: rightPanelContainer
//     property bool runMenuAnimation: false
//     // �����Ҳ���屳��͸�����ú����ǲ����ɫ͸����
//     color: "transparent"
//     visible: true
//     clip: true

//     // activeWidget: 0 = ����(Ĭ��), 1 = ��ͼȫ��, 2 = ����(����)ȫ��, 3 = ����(����)ȫ��
//     property int activeWidget: 0 

//     property int paddingVal: 16
//     property int cardSpacing: 16
//     property int bottomWidgetHeight: 180 

//     // ����Ϊ�ܿ��� UI ͷβ���Ŀ�϶
//     property int topSafeMargin: 80
//     property int bottomSafeMargin: 100

//     // ----------------------
//     // 1. ��ͼģ�� (��)
//     // ----------------------
//     Rectangle {
//         id: mapWidgetContainer
//         color: Style.isDark ? "#171717" : "#FFFFFF"
//         radius: 12
//         clip: true

//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.top: parent.top
        
//         // ȷ�������ܿ�ͷ�����������߽�
//         anchors.topMargin: topSafeMargin + paddingVal
//         anchors.leftMargin: paddingVal
//         anchors.rightMargin: paddingVal

//         height: activeWidget === 1 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) 
//                                    : (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2 - cardSpacing - bottomWidgetHeight)

//         opacity: activeWidget === 0 || activeWidget === 1 ? 1 : 0
//         visible: opacity > 0
//         z: activeWidget === 1 ? 99 : 1

//         Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
//         Behavior on opacity { NumberAnimation { duration: 300 } }

//         // �����ͼ��������û�д�������ܻ�հ�
//         NavigationMapScreen {
//             id: pageMap
//             anchors.fill: parent
//             enableGradient: false
//             background: Item {} // <-- ��һ���޸��޴�İ׿�
//             Component.onCompleted: pageMap.startAnimation()
//         }

//         // ˫���հ״����ԷŴ��ͼ
//         MouseArea {
//             anchors.fill: parent
//             acceptedButtons: Qt.NoButton
//             onDoubleClicked: activeWidget = activeWidget === 0 ? 1 : 0
//         }
        
//         // ���Ű�ť
//         Rectangle {
//             z: 100; width: 40; height: 40; radius: 20; color: Style.isDark ? "#333333" : "#F0F0F0"
//             anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 10
//             Text { text: activeWidget === 1 ? "" : ""; font.pixelSize: 18; color: Style.isDark ? "white" : "black"; anchors.centerIn: parent }
//             MouseArea { anchors.fill: parent; onClicked: activeWidget = activeWidget === 0 ? 1 : 0 }
//         }
//     }

//     // ----------------------
//     // 2. ����/Spotify ģ�� (����)
//     // ----------------------
//     Rectangle {
//         id: appsWidgetContainer
//         color: "#28292D"
//         radius: 12
//         clip: true

//         anchors.left: parent.left
//         anchors.right: parent.right 
//         anchors.bottom: parent.bottom

//         anchors.bottomMargin: bottomSafeMargin + paddingVal
//         anchors.leftMargin: paddingVal
        
//         // ����ʱ�ұ���һ�룬ȫ��ʱֻ�� padding
//         anchors.rightMargin: activeWidget === 2 ? paddingVal : (parent.width / 2 + cardSpacing / 2)
        
//         // ���ǲ�ֱ�Ӹı� anchors.top, ��ֻ�Ǹı� height���������Ա��� QML ����/ê��Լ������
//         height: activeWidget === 2 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : bottomWidgetHeight

//         opacity: activeWidget === 0 || activeWidget === 2 ? 1 : 0
//         visible: opacity > 0
//         z: activeWidget === 2 ? 99 : 1

//         Behavior on anchors.rightMargin { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
//         Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
//         Behavior on opacity { NumberAnimation { duration: 300 } }

//         MouseArea {
//             anchors.fill: parent
//             onClicked: activeWidget = activeWidget === 0 ? 2 : 0
//         }

//         // �������UI����
//         Item {
//             anchors.fill: parent
//             anchors.margins: 20

//             // ��ɫ����
//             Rectangle {
//                 id: albumCover
//                 width: 80; height: 80; radius: 8; color: "#1DB954"
//                 anchors.left: parent.left; anchors.top: parent.top; anchors.topMargin: 0
//                 Text { text: ""; font.pixelSize: 34; color: "white"; anchors.centerIn: parent }
//             }

//             // ����ͽ�����
//             ColumnLayout {
//                 anchors.left: albumCover.right; anchors.top: albumCover.top
//                 anchors.leftMargin: 15; anchors.right: spotifyLogo.left
//                 spacing: 4

//                 Text {
//                     text: "Tum Kya Mile - Rocky Aur Rani Kii P..."
//                     font.pixelSize: 16; font.family: "Inter"; font.weight: Font.Medium; color: "white"
//                     elide: Text.ElideRight; Layout.fillWidth: true
//                 }
//                 Text { text: "Tum Kya Mile"; font.pixelSize: 13; font.family: "Inter"; color: "#9E9E9E" }

//                 Item {
//                     Layout.fillWidth: true; height: 16; Layout.topMargin: 8
//                     Rectangle {
//                         width: parent.width; height: 3; radius: 1.5; color: "#555"; anchors.verticalCenter: parent.verticalCenter
//                         Rectangle { width: parent.width * 0.4; height: 3; radius: 1.5; color: "#1DB954" }
//                     }
//                 }
//             }

//             // SpotifyС��
//             Rectangle {
//                 id: spotifyLogo
//                 width: 24; height: 24; radius: 12; color: "#1DB954"
//                 anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 0
//                 Text { text: "S"; font.pixelSize: 12; font.bold: true; color: "white"; anchors.centerIn: parent }
//             }

//             // �ײ����Ʋ���
//             RowLayout {
//                 anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
//                 anchors.bottomMargin: 0
                
//                 Text { text: ""; color: "white"; font.pixelSize: 18; Layout.alignment: Qt.AlignLeft }
//                 Item { Layout.fillWidth: true }
//                 Text { text: ""; color: "white"; font.pixelSize: 22 }
//                 Rectangle {
//                     width: 44; height: 44; radius: 22; color: "#1DB954"
//                     Layout.margins: { left: 16; right: 16 }
//                     Text { text: ""; color: "white"; font.pixelSize: 20; anchors.centerIn: parent }
//                 }
//                 Text { text: ""; color: "white"; font.pixelSize: 22 }
//                 Item { Layout.fillWidth: true }
//                 Text { text: ""; color: "white"; font.pixelSize: 18; Layout.alignment: Qt.AlignRight }
//             }
//         }
//     }

//     // ----------------------
//     // 3. ���� ģ�� (����)
//     // ----------------------
//     Rectangle {
//         id: windowsWidgetContainer
//         color: "#03A9F4" 
//         radius: 12
//         clip: true

//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.bottom: parent.bottom

//         anchors.bottomMargin: bottomSafeMargin + paddingVal
//         anchors.rightMargin: paddingVal
        
//         // ����ʱ������������
//         anchors.leftMargin: activeWidget === 3 ? paddingVal : (parent.width / 2 + cardSpacing / 2)

//         height: activeWidget === 3 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : bottomWidgetHeight

//         opacity: activeWidget === 0 || activeWidget === 3 ? 1 : 0
//         visible: opacity > 0
//         z: activeWidget === 3 ? 99 : 1

//         Behavior on anchors.leftMargin { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
//         Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
//         Behavior on opacity { NumberAnimation { duration: 300 } }

//         MouseArea {
//             anchors.fill: parent
//             onClicked: activeWidget = activeWidget === 0 ? 3 : 0
//         }

//         // ����UI����
//         Item {
//             anchors.fill: parent
//             anchors.margins: 20

//             ColumnLayout {
//                 anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
//                 spacing: 4
//                 Text { text: "Gurugram"; font.pixelSize: 20; font.family: "Inter"; color: "white"; Layout.alignment: Qt.AlignHCenter }
//                 Text { text: "Today, August 19"; font.pixelSize: 15; font.family: "Inter"; color: "#E0E0E0"; Layout.alignment: Qt.AlignHCenter }
//             }

//             Text {
//                 text: "Mist"
//                 font.pixelSize: 20; font.family: "Inter"; color: "#BBDEFB"
//                 anchors.left: parent.left; anchors.bottom: parent.bottom
//                 anchors.leftMargin: 10; anchors.bottomMargin: 10
//             }

//             ColumnLayout {
//                 anchors.right: parent.right; anchors.bottom: parent.bottom
//                 anchors.rightMargin: 10; anchors.bottomMargin: -5
//                 spacing: -5
                
//                 Text { text: "31"; font.pixelSize: 52; font.family: "Inter"; font.weight: Font.Light; color: "white"; Layout.alignment: Qt.AlignRight }
//                 Text { text: "31"; font.pixelSize: 22; font.family: "Inter"; color: "#90CAF9"; Layout.alignment: Qt.AlignRight; Layout.rightMargin: 5 }
//             }

//             Text {
//                 text: ""
//                 font.pixelSize: 70
//                 anchors.centerIn: parent
//                 anchors.verticalCenterOffset: 15
//                 anchors.horizontalCenterOffset: -20
//             }
//         }
//     }
// }



import QtQuick 2.9
import QtLocation 5.6
import QtQml 2.3
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtPositioning 5.6
import QtQuick.Layouts 1.3
import Style 1.0

Rectangle {
    id: rightPanelContainer
    property bool runMenuAnimation: false
    // 整体背景透明让底层UI透过来
    color: "transparent"
    visible: true
    clip: true

    // activeWidget: 0 = 分屏(默认), 1 = 地图全屏, 2 = 音乐(左下)全屏, 3 = 天气(右下)全屏
    property int activeWidget: 0 

    property int paddingVal: 15
    property int cardSpacing: 15
    property int bottomWidgetHeight: 180 

    property int topSafeMargin: 80
    property int bottomSafeMargin: 90

    // ----------------------
    // 1. 地图模块 (上)
    // ----------------------
    Rectangle {
        id: mapWidgetContainer
        color: Style.isDark ? "#171717" : "#FFFFFF"
        radius: 12
        clip: true

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        
        anchors.topMargin: topSafeMargin + paddingVal
        anchors.leftMargin: paddingVal
        anchors.rightMargin: paddingVal

        height: activeWidget === 1 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) 
                                   : (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2 - cardSpacing - bottomWidgetHeight)

        opacity: activeWidget === 0 || activeWidget === 1 ? 1 : 0
        visible: opacity > 0
        z: activeWidget === 1 ? 99 : 1

        Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
        Behavior on opacity { NumberAnimation { duration: 300 } }

        NavigationMapScreen {
            id: pageMap
            anchors.fill: parent
            enableGradient: false
            background: Item {} // 这里解决了由于Page默认颜色导致的巨型白屏问题！
            Component.onCompleted: pageMap.startAnimation()
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onDoubleClicked: activeWidget = activeWidget === 0 ? 1 : 0
        }
        
        Rectangle {
            z: 100; width: 40; height: 40; radius: 20; color: Style.isDark ? "#333333" : "#F0F0F0"
            anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 10
            Text { text: activeWidget === 1 ? "↙" : "↗"; font.pixelSize: 18; color: Style.isDark ? "white" : "black"; anchors.centerIn: parent }
            MouseArea { anchors.fill: parent; onClicked: activeWidget = activeWidget === 0 ? 1 : 0 }
        }
    }

    // ----------------------
    // 2. 音乐/媒体 模块 (左下)
    // ----------------------
    Rectangle {
        id: appsWidgetContainer
        color: "#28292D"
        radius: 12
        clip: true

        anchors.left: parent.left
        anchors.right: parent.right 
        anchors.bottom: parent.bottom

        anchors.bottomMargin: bottomSafeMargin + paddingVal
        anchors.leftMargin: paddingVal
        
        anchors.rightMargin: activeWidget === 2 ? paddingVal : (parent.width / 2 + cardSpacing / 2)
        height: activeWidget === 2 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : bottomWidgetHeight

        opacity: activeWidget === 0 || activeWidget === 2 ? 1 : 0
        visible: opacity > 0
        z: activeWidget === 2 ? 99 : 1

        Behavior on anchors.rightMargin { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
        Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
        Behavior on opacity { NumberAnimation { duration: 300 } }

        // --- 内部播放状态数据预留设定 ---
        property bool isPlaying: false
        property real currentProgress: 0.3
        property string currentSongTitle: "Tum Kya Mile - Rocky Rani"
        property string currentArtist: "Pritam, Arijit Singh"
        property string currentDuration: "3:12"

        // 将基础背景点击作为放大触发，防止遮挡内部按钮的点击
        MouseArea {
            anchors.fill: parent
            z: 0 // 置于最底
            onClicked: activeWidget = activeWidget === 0 ? 2 : 0
        }

        Item {
            anchors.fill: parent

            // ==== 全屏播放列表区域 (只在点击放大拉高后才会呈现) ====
            Item {
                id: playlistArea
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: playerControlBar.top
                opacity: activeWidget === 2 ? 1 : 0
                visible: opacity > 0
                Behavior on opacity { NumberAnimation { duration: 300 } }
                
                Text {
                    id: listHeader
                    text: "播放队列"
                    font.pixelSize: 22
                    color: "white"
                    font.bold: true
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 20
                }

                ListView {
                    id: songList
                    anchors.top: listHeader.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 10
                    clip: true
                    model: ListModel {
                        ListElement { songTitle: "Tum Kya Mile"; songArtist: "Pritam"; duration: "3:12"; isPlay: true }
                        ListElement { songTitle: "What Jhumka?"; songArtist: "Arijit Singh"; duration: "2:54"; isPlay: false }
                        ListElement { songTitle: "Ve Kamleya"; songArtist: "Shreya Ghoshal"; duration: "4:01"; isPlay: false }
                        ListElement { songTitle: "Rani Mehel"; songArtist: "Jonita Gandhi"; duration: "3:45"; isPlay: false }
                        ListElement { songTitle: "Chaleya"; songArtist: "Arijit Singh"; duration: "3:20"; isPlay: false }
                    }
                    delegate: Rectangle {
                        width: songList.width
                        height: 60
                        color: itemMouseArea.containsMouse ? "#3A3B3C" : "transparent"
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            spacing: 15
                            
                            // 列表里的单曲播放/暂停按钮
                            Rectangle {
                                width: 34; height: 34; radius: 17
                                color: isPlay ? "#1DB954" : "transparent"
                                border.color: isPlay ? "#1DB954" : "#FFFFFF"
                                border.width: isPlay ? 0 : 1
                                Text { 
                                    text: isPlay ? "⏸" : "▶"
                                    color: isPlay ? "white" : "#AAAAAA"
                                    anchors.centerIn: parent; font.pixelSize: 14 
                                    anchors.horizontalCenterOffset: isPlay ? 0 : 2
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onPressed: parent.scale = 0.9; onReleased: parent.scale = 1.0
                                    onClicked: { console.log("从音乐列表切换单曲: " + index) }
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text { text: songTitle; color: isPlay ? "#1DB954" : "white"; font.pixelSize: 16 }
                                Text { text: songArtist; color: "#9E9E9E"; font.pixelSize: 13 }
                            }
                            Text { text: duration; color: "#9E9E9E"; font.pixelSize: 14 }
                        }
                        MouseArea {
                            id: itemMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            z: -1
                        }
                    }
                }
            }

            // ==== 底部控制条 (缩小模式下占满空间，放大后贴于底部) ====
            Item {
                id: playerControlBar
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: activeWidget === 2 ? 100 : parent.height

                // 全屏时的顶部分割线
                Rectangle {
                    width: parent.width; height: 1; color: "#444"
                    visible: activeWidget === 2; anchors.top: parent.top
                }

                // 全屏大结构时贯通横向的进度条
                Slider {
                    id: mainSlider
                    anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
                    anchors.topMargin: -8 
                    visible: activeWidget === 2; z: 10
                    from: 0; to: 100; value: appsWidgetContainer.currentProgress * 100
                    onMoved: appsWidgetContainer.currentProgress = value / 100
                    
                    background: Rectangle {
                        x: mainSlider.leftPadding; y: mainSlider.topPadding + mainSlider.availableHeight / 2 - height / 2
                        width: mainSlider.availableWidth; height: 4; radius: 2; color: "transparent"
                        Rectangle {
                            width: mainSlider.visualPosition * parent.width; height: parent.height
                            color: "#1DB954"; radius: 2
                        }
                    }
                    handle: Rectangle {
                        x: mainSlider.leftPadding + mainSlider.visualPosition * (mainSlider.availableWidth - width)
                        y: mainSlider.topPadding + mainSlider.availableHeight / 2 - height / 2
                        implicitWidth: 12; implicitHeight: 12; radius: 6
                        color: mainSlider.pressed ? "#1DB954" : "#FFFFFF"
                        opacity: (mainSlider.hovered || mainSlider.pressed) ? 1 : 0 
                    }
                }

                // 封面
                Rectangle {
                    id: albumCover
                    width: activeWidget === 2 ? 64 : 80
                    height: width
                    radius: 8
                    color: "#16A34A"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: 20

                    Image {
                        id: coverImg
                        anchors.fill: parent
                        source: "qrc:/icons/music_placeholder.png" // 预留接口，放入真实图片后自动显示盖住字
                        visible: status === Image.Ready
                    }
                    Text { 
                        text: "🎵"
                        font.pixelSize: activeWidget === 2 ? 28 : 34
                        color: "white"; anchors.centerIn: parent 
                        visible: !coverImg.visible
                    }
                }

                // 中心音乐信息文字与迷你进度条
                ColumnLayout {
                    anchors.left: albumCover.right; anchors.top: albumCover.top
                    anchors.right: playerControls.left
                    anchors.bottom: activeWidget === 2 ? albumCover.bottom : undefined
                    anchors.leftMargin: 15; anchors.rightMargin: 15
                    spacing: 4

                    Text {
                        text: appsWidgetContainer.currentSongTitle
                        font.pixelSize: 16; font.family: "Inter"; font.weight: Font.Medium; color: "white"
                        elide: Text.ElideRight; Layout.fillWidth: true
                        verticalAlignment: Qt.AlignVCenter
                        Layout.fillHeight: activeWidget === 2
                    }
                    Text { 
                        text: appsWidgetContainer.currentArtist
                        font.pixelSize: 13; font.family: "Inter"; color: "#9E9E9E" 
                        visible: activeWidget !== 2 // 缩小模式下才显示两排详细副标题
                    }

                    // 分屏时显示的迷你进度条（带拖动）
                    Item {
                        Layout.fillWidth: true; height: 16; Layout.topMargin: 8
                        visible: activeWidget !== 2 
                        Slider {
                            id: miniSlider
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            from: 0; to: 100; value: appsWidgetContainer.currentProgress * 100
                            onMoved: appsWidgetContainer.currentProgress = value / 100
                            
                            background: Rectangle {
                                x: miniSlider.leftPadding; y: miniSlider.topPadding + miniSlider.availableHeight / 2 - height / 2
                                width: miniSlider.availableWidth; height: 4; radius: 2; color: "#555"
                                Rectangle {
                                    width: miniSlider.visualPosition * parent.width; height: parent.height
                                    color: "#1DB954"; radius: 2
                                }
                            }
                            handle: Rectangle {
                                x: miniSlider.leftPadding + miniSlider.visualPosition * (miniSlider.availableWidth - width)
                                y: miniSlider.topPadding + miniSlider.availableHeight / 2 - height / 2
                                implicitWidth: 12; implicitHeight: 12; radius: 6
                                color: "#FFFFFF"
                                opacity: miniSlider.pressed ? 1 : 0 
                            }
                        }
                    }
                }

                // 播放控制按钮区组件
                RowLayout {
                    id: playerControls
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.bottom: activeWidget !== 2 ? parent.bottom : undefined
                    anchors.bottomMargin: activeWidget !== 2 ? 0 : undefined
                    anchors.top: activeWidget === 2 ? parent.top : undefined // 全屏时垂直居中对齐用
                    height: activeWidget === 2 ? parent.height : 60
                    spacing: activeWidget === 2 ? 15 : 0
                    
                    // 随机播放
                    Item { 
                        width: 30; height: 30; Layout.alignment: Qt.AlignVCenter
                        Image { id: btnShuffle; source: "qrc:/icons/shuffle.png"; anchors.fill: parent; fillMode: Image.PreserveAspectFit; visible: status === Image.Ready }
                        Text { text: "🔀"; color: "white"; font.pixelSize: 18; anchors.centerIn: parent; visible: !btnShuffle.visible }
                        MouseArea { 
                            anchors.fill: parent; onClicked: console.log("Shuffle")
                            onPressed: parent.opacity=0.6; onReleased: parent.opacity=1.0; Behavior on opacity {NumberAnimation{}}
                        }
                    }
                    Item { Layout.fillWidth: true; visible: activeWidget !== 2 }

                    // 上一首
                    Item {
                        width: 30; height: 30; Layout.alignment: Qt.AlignVCenter
                        Image { id: btnPrev; source: "qrc:/icons/prev.png"; anchors.fill: parent; fillMode: Image.PreserveAspectFit; visible: status === Image.Ready }
                        Text { text: "⏮"; color: "white"; font.pixelSize: 24; anchors.centerIn: parent; visible: !btnPrev.visible } 
                        MouseArea { 
                            anchors.fill: parent
                            onPressed: parent.scale = 0.8; onReleased: parent.scale = 1.0; Behavior on scale { NumberAnimation { duration: 100 } }
                            onClicked: console.log("上一首") 
                        }
                    }

                    // 播放/暂停 动态主核心建
                    Rectangle {
                        width: 48; height: 48; radius: 24; color: "#1DB954"
                        Layout.alignment: Qt.AlignVCenter
                        Layout.margins: { left: 10; right: 10 }
                        
                        Image { 
                            id: btnPlay
                            source: appsWidgetContainer.isPlaying ? "qrc:/icons/pause.png" : "qrc:/icons/play.png"
                            anchors.centerIn: parent; width: 24; height: 24
                            fillMode: Image.PreserveAspectFit
                            visible: status === Image.Ready
                        }
                        Text { 
                            text: appsWidgetContainer.isPlaying ? "⏸" : "▶"
                            color: "white"; font.pixelSize: 22; anchors.centerIn: parent 
                            visible: !btnPlay.visible 
                            anchors.horizontalCenterOffset: appsWidgetContainer.isPlaying ? 0 : 3
                            anchors.verticalCenterOffset: appsWidgetContainer.isPlaying ? -1 : 0
                        }
                        MouseArea { 
                            anchors.fill: parent
                            onPressed: parent.scale = 0.85; onReleased: parent.scale = 1.0; Behavior on scale { NumberAnimation { duration: 100 } }
                            onClicked: appsWidgetContainer.isPlaying = !appsWidgetContainer.isPlaying 
                        }
                    }

                    // 下一首
                    Item {
                        width: 30; height: 30; Layout.alignment: Qt.AlignVCenter
                        Image { id: btnNext; source: "qrc:/icons/next.png"; anchors.fill: parent; fillMode: Image.PreserveAspectFit; visible: status === Image.Ready }
                        Text { text: "⏭"; color: "white"; font.pixelSize: 24; anchors.centerIn: parent; visible: !btnNext.visible } 
                        MouseArea { 
                            anchors.fill: parent
                            onPressed: parent.scale = 0.8; onReleased: parent.scale = 1.0; Behavior on scale { NumberAnimation { duration: 100 } }
                            onClicked: console.log("下一首") 
                        }
                    }

                    Item { Layout.fillWidth: true; visible: activeWidget !== 2 }

                    // 循环播放
                    Item { 
                        width: 30; height: 30; Layout.alignment: Qt.AlignVCenter
                        Image { id: btnRepeat; source: "qrc:/icons/repeat.png"; anchors.fill: parent; fillMode: Image.PreserveAspectFit; visible: status === Image.Ready }
                        Text { text: "🔁"; color: "white"; font.pixelSize: 18; anchors.centerIn: parent; visible: !btnRepeat.visible }
                        MouseArea { 
                            anchors.fill: parent; onClicked: console.log("Repeat") 
                            onPressed: parent.opacity=0.6; onReleased: parent.opacity=1.0; Behavior on opacity {NumberAnimation{}}
                        }
                    }
                }
            }
        }
    }

    // ----------------------
    // 3. 天气 模块 (右下)
    // ----------------------
    Rectangle {
        id: windowsWidgetContainer
        color: "#03A9F4" 
        radius: 12
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

        Behavior on anchors.leftMargin { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
        Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }
        Behavior on opacity { NumberAnimation { duration: 300 } }

        MouseArea {
            anchors.fill: parent
            onClicked: activeWidget = activeWidget === 0 ? 3 : 0
        }

        Item {
            anchors.fill: parent
            anchors.margins: 20

            ColumnLayout {
                anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
                spacing: 4
                Text { text: "Gurugram"; font.pixelSize: 20; font.family: "Inter"; color: "white"; Layout.alignment: Qt.AlignHCenter }
                Text { text: "Today, August 19"; font.pixelSize: 15; font.family: "Inter"; color: "#E0E0E0"; Layout.alignment: Qt.AlignHCenter }
            }

            Text {
                text: "Mist"
                font.pixelSize: 20; font.family: "Inter"; color: "#BBDEFB"
                anchors.left: parent.left; anchors.bottom: parent.bottom
                anchors.leftMargin: 10; anchors.bottomMargin: 10
            }

            ColumnLayout {
                anchors.right: parent.right; anchors.bottom: parent.bottom
                anchors.rightMargin: 10; anchors.bottomMargin: -5
                spacing: -5
                
                Text { text: "31°"; font.pixelSize: 52; font.family: "Inter"; font.weight: Font.Light; color: "white"; Layout.alignment: Qt.AlignRight }
                Text { text: "31°"; font.pixelSize: 22; font.family: "Inter"; color: "#90CAF9"; Layout.alignment: Qt.AlignRight; Layout.rightMargin: 5 }
            }

            Text {
                text: "☁️⛅"
                font.pixelSize: 70
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 15
                anchors.horizontalCenterOffset: -20
            }
        }
    }
}