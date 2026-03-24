import QtQuick 2.9
import QtLocation 5.6
import QtQml 2.3
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtPositioning 5.6
import QtQuick.Layouts 1.3
import Style 1.0

// Rectangle {
//     id: rightPanelContainer
//     // 这个必须保留，防止你的 main.qml 调用报错
//     property bool runMenuAnimation: false
//     color: "transparent"
//     visible: true
//     clip: true

//     // activeWidget: 0 = 分屏, 1 = 地图全屏, 2 = 音乐全屏, 3 = 天气全屏
//     property int activeWidget: 0

//     property int paddingVal: 20
//     property int cardSpacing: 20
//     property int bottomWidgetHeight: 180
//     property int topSafeMargin: 50
//     property int bottomSafeMargin: 120

//     // 卡片背景风格
//     property color cardBackgroundColor: "#1C1C1E"
//     property color cardBorderColor: "#38383A"

//     // ==========================================
//     // 后期对接真实数据的接口 (预留属性)
//     // ==========================================
//     // 音乐接口
//     property bool musicIsPlaying: false
//     property real musicProgress: 0.35 // 0.0 到 1.0
//     property string musicTitle: "Blinding Lights"
//     property string musicArtist: "The Weeknd"
//     property string musicDurationText: "3:20"
//     property string musicCurrentTimeText: "1:10"
//     property string musicCoverPath: "qrc:/icons/cover_placeholder.jpg"

//     // 天气接口
//     property string weatherCity: "Cupertino"
//     property string weatherDate: "Tuesday, March 24"
//     property string weatherTemp: "22°"
//     property string weatherCondition: "Partly Cloudy"
//     property string weatherHighLow: "H:26° L:14°"
//     property string weatherIconPath: "qrc:/icons/weather_cloud.png"

//     // ----------------------
//     // 1. 地图模块
//     // ----------------------
//     Rectangle {
//         id: mapWidgetContainer
//         color: cardBackgroundColor
//         radius: 16
//         border.color: cardBorderColor
//         border.width: 1
//         clip: true

//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.top: parent.top
//         anchors.topMargin: topSafeMargin + paddingVal
//         anchors.leftMargin: paddingVal
//         anchors.rightMargin: paddingVal

//         height: activeWidget === 1 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2)
//                                    : (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2 - cardSpacing - bottomWidgetHeight)

//         opacity: activeWidget === 0 || activeWidget === 1 ? 1 : 0
//         visible: opacity > 0
//         z: activeWidget === 1 ? 99 : 1

//         Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.InOutQuart } }
//         Behavior on opacity { NumberAnimation { duration: 300 } }

//         // NavigationMapScreen { anchors.fill: parent }

//         MouseArea {
//             anchors.fill: parent
//             onDoubleClicked: activeWidget = activeWidget === 0 ? 1 : 0
//         }

//         Rectangle {
//             z: 100; width: 44; height: 44; radius: 22
//             color: "#80000000"; border.color: "#40FFFFFF"; border.width: 1
//             anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 16
//             Text { text: activeWidget === 1 ? "↙" : "↗"; font.pixelSize: 18; color: "white"; anchors.centerIn: parent }
//             MouseArea {
//                 anchors.fill: parent; onClicked: activeWidget = activeWidget === 0 ? 1 : 0
//                 onPressed: parent.opacity = 0.6; onReleased: parent.opacity = 1.0
//             }
//         }
//     }

//     // ----------------------
//     // 2. 音乐模块 (修复版)
//     // ----------------------
//     Rectangle {
//         id: musicWidgetContainer
//         color: cardBackgroundColor
//         radius: 16
//         border.color: cardBorderColor
//         border.width: 1
//         clip: true

//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.bottom: parent.bottom
//         anchors.bottomMargin: bottomSafeMargin + paddingVal
//         anchors.leftMargin: paddingVal

//         anchors.rightMargin: activeWidget === 2 ? paddingVal : (parent.width / 2 + cardSpacing / 2)
//         height: activeWidget === 2 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : bottomWidgetHeight

//         opacity: activeWidget === 0 || activeWidget === 2 ? 1 : 0
//         visible: opacity > 0
//         z: activeWidget === 2 ? 99 : 1

//         Behavior on anchors.rightMargin { NumberAnimation { duration: 400; easing.type: Easing.InOutQuart } }
//         Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.InOutQuart } }
//         Behavior on opacity { NumberAnimation { duration: 300 } }

//         MouseArea {
//             anchors.fill: parent; z: 0
//             onClicked: activeWidget = activeWidget === 0 ? 2 : 0
//         }

//         // ==========================================
//         // 迷你模式 UI
//         // ==========================================
//         Item {
//             anchors.fill: parent
//             anchors.margins: 16
//             opacity: activeWidget === 2 ? 0 : 1
//             visible: opacity > 0
//             Behavior on opacity { NumberAnimation { duration: 200 } }

//             RowLayout {
//                 anchors.fill: parent; spacing: 16
//                 Rectangle {
//                     width: bottomWidgetHeight - 32; height: width; radius: 10
//                     color: "#2C2C2E"; clip: true
//                     Image {
//                         anchors.fill: parent; source: musicCoverPath; fillMode: Image.PreserveAspectCrop; visible: status === Image.Ready
//                     }
//                     Text { text: "🎵"; color: "#8E8E93"; font.pixelSize: 32; anchors.centerIn: parent; visible: !parent.children[0].visible }
//                 }

//                 ColumnLayout {
//                     Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter; spacing: 4
//                     Text { text: musicTitle; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#FFFFFF"; elide: Text.ElideRight; Layout.fillWidth: true }
//                     Text { text: musicArtist; font.pixelSize: 16; color: "#8E8E93"; elide: Text.ElideRight; Layout.fillWidth: true }
//                 }

//                 RowLayout {
//                     spacing: 16
//                     Rectangle {
//                         width: 48; height: 48; radius: 24; color: musicIsPlaying ? "#3A3A3C" : "#FFFFFF"
//                         Image {
//                             source: musicIsPlaying ? "qrc:/icons/pause_black.png" : "qrc:/icons/play_black.png"
//                             anchors.centerIn: parent; width: 20; height: 20; fillMode: Image.PreserveAspectFit; visible: status === Image.Ready
//                         }
//                         Text { text: musicIsPlaying ? "⏸" : "▶"; color: musicIsPlaying ? "white" : "black"; font.pixelSize: 20; anchors.centerIn: parent; visible: !parent.children[0].visible; anchors.horizontalCenterOffset: musicIsPlaying?0:2 }
//                         MouseArea {
//                             anchors.fill: parent; onClicked: { musicIsPlaying = !musicIsPlaying; mouse.accepted = true; }
//                             onPressed: parent.scale = 0.9; onReleased: parent.scale = 1.0; Behavior on scale { NumberAnimation{ duration: 100 } }
//                         }
//                     }
//                     Rectangle {
//                         width: 48; height: 48; radius: 24; color: "transparent"
//                         Image { source: "qrc:/icons/next_white.png"; anchors.centerIn: parent; width: 24; height: 24; fillMode: Image.PreserveAspectFit; visible: status === Image.Ready }
//                         Text { text: "⏭"; color: "#FFFFFF"; font.pixelSize: 24; anchors.centerIn: parent; visible: !parent.children[0].visible }
//                         MouseArea {
//                             anchors.fill: parent; onClicked: { console.log("Next"); mouse.accepted = true; }
//                             onPressed: parent.opacity = 0.5; onReleased: parent.opacity = 1.0; Behavior on opacity { NumberAnimation{ duration: 100 } }
//                         }
//                     }
//                 }
//             }
//         }

//         // ==========================================
//         // 全屏模式 UI
//         // ==========================================
//         Item {
//             anchors.fill: parent
//             opacity: activeWidget === 2 ? 1 : 0
//             visible: opacity > 0
//             Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }

//             // ---------------- 左侧主控区 ----------------
//             Item {
//                 width: parent.width * 0.55
//                 anchors.left: parent.left
//                 anchors.top: parent.top; anchors.bottom: parent.bottom

//                 ColumnLayout {
//                     anchors.fill: parent
//                     anchors.margins: 40 // iOS 宽大的留白
//                     spacing: 20

//                     // 1. 大封面区 (自适应填充剩余空间，绝不越界)
//                     Item {
//                         Layout.fillWidth: true
//                         Layout.fillHeight: true // 只有封面区允许拉伸

//                         Rectangle {
//                             id: coverRect
//                             // 保持完美正方形
//                             width: Math.min(parent.width, parent.height)
//                             height: width
//                             anchors.centerIn: parent
//                             radius: 16
//                             color: "#2C2C2E"

//                             Image {
//                                 id: fullCoverImg
//                                 anchors.fill: parent; anchors.margins: 1
//                                 source: musicCoverPath
//                                 fillMode: Image.PreserveAspectCrop
//                                 visible: status === Image.Ready
//                                 layer.enabled: true
//                                 layer.effect: OpacityMask { maskSource: Rectangle { width: coverRect.width; height: coverRect.height; radius: 15 } }
//                             }
//                             Text {
//                                 text: "🎵"
//                                 color: "#555"
//                                 font.pixelSize: coverRect.width * 0.4
//                                 anchors.centerIn: parent
//                                 visible: !fullCoverImg.visible
//                             }
//                         }
//                     }

//                     // 2. 歌曲信息 (锁定高度)
//                     RowLayout {
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: 60

//                         ColumnLayout {
//                             Layout.fillWidth: true; spacing: 4
//                             Text { text: musicTitle; font.pixelSize: 28; font.weight: Font.Bold; color: "#FFFFFF"; elide: Text.ElideRight; Layout.fillWidth: true }
//                             Text { text: musicArtist; font.pixelSize: 20; color: "#FA114F"; elide: Text.ElideRight; Layout.fillWidth: true }
//                         }
//                         Rectangle {
//                             Layout.preferredWidth: 32; Layout.preferredHeight: 32; radius: 16; color: "#3A3A3C"
//                             Text { text: "•••"; color: "white"; font.pixelSize: 14; anchors.centerIn: parent; anchors.verticalCenterOffset: -2 }
//                             MouseArea { anchors.fill: parent; onClicked: mouse.accepted = true; onPressed: parent.opacity=0.6; onReleased: parent.opacity=1.0 }
//                         }
//                     }

//                     // 3. 拖动进度条 (锁定高度)
//                     ColumnLayout {
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: 50
//                         spacing: 8

//                         Slider {
//                             id: fullSlider
//                             Layout.fillWidth: true; Layout.preferredHeight: 24
//                             from: 0; to: 100; value: musicProgress * 100
//                             onMoved: musicProgress = value / 100

//                             background: Rectangle {
//                                 y: parent.height / 2 - height / 2; width: parent.width; height: 6; radius: 3; color: "#3A3A3C"
//                                 Rectangle { width: parent.visualPosition * parent.width; height: parent.height; color: "#FFFFFF"; radius: 3 }
//                             }
//                             handle: Rectangle {
//                                 x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
//                                 y: parent.topPadding + parent.availableHeight / 2 - height / 2
//                                 width: fullSlider.pressed ? 20 : 8; height: width; radius: width/2; color: "#FFFFFF"
//                                 Behavior on width { NumberAnimation { duration: 150 } }
//                             }
//                         }
//                         RowLayout {
//                             Layout.fillWidth: true
//                             Text { text: musicCurrentTimeText; color: "#8E8E93"; font.pixelSize: 12; font.weight: Font.DemiBold }
//                             Item { Layout.fillWidth: true }
//                             Text { text: "-" + musicDurationText; color: "#8E8E93"; font.pixelSize: 12; font.weight: Font.DemiBold }
//                         }
//                     }

//                     // 4. 控制盘 (锁定高度)
//                     RowLayout {
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: 80
//                         Layout.alignment: Qt.AlignHCenter
//                         spacing: 10

//                         Item { Layout.fillWidth: true } // 左弹簧占位

//                         // 随机
//                         Item {
//                             Layout.preferredWidth: 40; Layout.preferredHeight: 40; opacity: 0.8
//                             Image { source: "qrc:/icons/shuffle.png"; anchors.centerIn: parent; width: 24; height: 24; fillMode: Image.PreserveAspectFit; visible: status===Image.Ready }
//                             Text { text: "🔀"; color: "#FFFFFF"; font.pixelSize: 20; anchors.centerIn: parent; visible: !parent.children[0].visible }
//                             MouseArea { anchors.fill: parent; onClicked: mouse.accepted=true; onPressed: parent.opacity=0.4; onReleased: parent.opacity=0.8 }
//                         }

//                         Item { Layout.preferredWidth: 20 }

//                         // 上一首
//                         Item {
//                             Layout.preferredWidth: 50; Layout.preferredHeight: 50
//                             Image { source: "qrc:/icons/prev.png"; anchors.centerIn: parent; width: 32; height: 32; fillMode: Image.PreserveAspectFit; visible: status===Image.Ready }
//                             Text { text: "⏮"; color: "#FFFFFF"; font.pixelSize: 32; anchors.centerIn: parent; visible: !parent.children[0].visible }
//                             MouseArea { anchors.fill: parent; onClicked: mouse.accepted=true; onPressed: parent.opacity=0.5; onReleased: parent.opacity=1.0 }
//                         }

//                         Item { Layout.preferredWidth: 10 }

//                         // 播放主按钮
//                         Rectangle {
//                             Layout.preferredWidth: 72; Layout.preferredHeight: 72; radius: 36
//                             color: musicIsPlaying ? "#3A3A3C" : "#FFFFFF"
//                             Image {
//                                 source: musicIsPlaying ? "qrc:/icons/pause.png" : "qrc:/icons/play.png"
//                                 anchors.centerIn: parent; width: 32; height: 32; fillMode: Image.PreserveAspectFit
//                                 visible: status===Image.Ready
//                             }
//                             Text {
//                                 text: musicIsPlaying ? "⏸" : "▶"
//                                 color: musicIsPlaying ? "white" : "black"
//                                 font.pixelSize: 32; anchors.centerIn: parent; visible: !parent.children[0].visible
//                                 anchors.horizontalCenterOffset: musicIsPlaying?0:4
//                             }
//                             MouseArea {
//                                 anchors.fill: parent; onClicked: { musicIsPlaying = !musicIsPlaying; mouse.accepted=true; }
//                                 onPressed: parent.scale = 0.9; onReleased: parent.scale = 1.0; Behavior on scale { NumberAnimation { duration: 100 } }
//                             }
//                         }

//                         Item { Layout.preferredWidth: 10 }

//                         // 下一首
//                         Item {
//                             Layout.preferredWidth: 50; Layout.preferredHeight: 50
//                             Image { source: "qrc:/icons/next.png"; anchors.centerIn: parent; width: 32; height: 32; fillMode: Image.PreserveAspectFit; visible: status===Image.Ready }
//                             Text { text: "⏭"; color: "#FFFFFF"; font.pixelSize: 32; anchors.centerIn: parent; visible: !parent.children[0].visible }
//                             MouseArea { anchors.fill: parent; onClicked: mouse.accepted=true; onPressed: parent.opacity=0.5; onReleased: parent.opacity=1.0 }
//                         }

//                         Item { Layout.preferredWidth: 20 }

//                         // 循环
//                         Item {
//                             Layout.preferredWidth: 40; Layout.preferredHeight: 40; opacity: 0.8
//                             Image { source: "qrc:/icons/repeat.png"; anchors.centerIn: parent; width: 24; height: 24; fillMode: Image.PreserveAspectFit; visible: status===Image.Ready }
//                             Text { text: "🔁"; color: "#FFFFFF"; font.pixelSize: 20; anchors.centerIn: parent; visible: !parent.children[0].visible }
//                             MouseArea { anchors.fill: parent; onClicked: mouse.accepted=true; onPressed: parent.opacity=0.4; onReleased: parent.opacity=0.8 }
//                         }

//                         Item { Layout.fillWidth: true } // 右弹簧占位
//                     }
//                 }
//             }

//             // ---------------- 右侧列表区 ----------------
//             Item {
//                 anchors.left: parent.children[0].right
//                 anchors.right: parent.right
//                 anchors.top: parent.top; anchors.bottom: parent.bottom
//                 anchors.margins: 40

//                 Text {
//                     id: listHeaderTitle
//                     text: "待播清单"
//                     font.pixelSize: 24; font.weight: Font.Bold; color: "white"
//                     anchors.top: parent.top
//                 }

//                 ListView {
//                     anchors.top: listHeaderTitle.bottom; anchors.topMargin: 24
//                     anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
//                     clip: true; spacing: 12
//                     model: ListModel {
//                         ListElement { songName: "Starboy"; artistName: "The Weeknd"; coverImg: "qrc:/icons/list1.jpg" }
//                         ListElement { songName: "Save Your Tears"; artistName: "The Weeknd"; coverImg: "qrc:/icons/list2.jpg" }
//                         ListElement { songName: "Die For You"; artistName: "The Weeknd"; coverImg: "qrc:/icons/list3.jpg" }
//                         ListElement { songName: "Out of Time"; artistName: "The Weeknd"; coverImg: "qrc:/icons/list4.jpg" }
//                         ListElement { songName: "Less Than Zero"; artistName: "The Weeknd"; coverImg: "qrc:/icons/list5.jpg" }
//                     }
//                     delegate: Rectangle {
//                         width: parent.width; height: 64; radius: 12
//                         color: itemMouseArea.pressed ? "#3A3A3C" : "transparent"
//                         Behavior on color { ColorAnimation { duration: 100 } }

//                         RowLayout {
//                             anchors.fill: parent; anchors.margins: 8; spacing: 16
//                             Rectangle {
//                                 width: 48; height: 48; radius: 6; color: "#2C2C2E"; clip: true
//                                 Image { source: coverImg; anchors.fill: parent; fillMode: Image.PreserveAspectCrop; visible: status===Image.Ready }
//                             }
//                             ColumnLayout {
//                                 Layout.fillWidth: true; spacing: 2
//                                 Text { text: songName; color: "#FFFFFF"; font.pixelSize: 16; font.weight: Font.DemiBold }
//                                 Text { text: artistName; color: "#8E8E93"; font.pixelSize: 14 }
//                             }
//                             Text { text: "≡"; color: "#8E8E93"; font.pixelSize: 24; Layout.rightMargin: 10 }
//                         }
//                         MouseArea { id: itemMouseArea; anchors.fill: parent; onClicked: { mouse.accepted = true; } }
//                     }
//                 }
//             }
//         }
//     }

//     // ----------------------
//     // 3. 天气模块
//     // ----------------------
//     Rectangle {
//         id: weatherWidgetContainer
//         radius: 16
//         clip: true

//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.bottom: parent.bottom
//         anchors.bottomMargin: bottomSafeMargin + paddingVal
//         anchors.rightMargin: paddingVal

//         anchors.leftMargin: activeWidget === 3 ? paddingVal : (parent.width / 2 + cardSpacing / 2)
//         height: activeWidget === 3 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : bottomWidgetHeight

//         opacity: activeWidget === 0 || activeWidget === 3 ? 1 : 0
//         visible: opacity > 0
//         z: activeWidget === 3 ? 99 : 1

//         Behavior on anchors.leftMargin { NumberAnimation { duration: 400; easing.type: Easing.InOutQuart } }
//         Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.InOutQuart } }
//         Behavior on opacity { NumberAnimation { duration: 300 } }

//         LinearGradient {
//             anchors.fill: parent
//             start: Qt.point(0, 0); end: Qt.point(parent.width, parent.height)
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: "#2E335A" }
//                 GradientStop { position: 1.0; color: "#1C1B33" }
//             }
//         }

//         Rectangle { anchors.fill: parent; radius: 16; color: "transparent"; border.color: "#40FFFFFF"; border.width: 1 }

//         MouseArea {
//             anchors.fill: parent; onClicked: activeWidget = activeWidget === 0 ? 3 : 0
//         }

//         Item {
//             anchors.fill: parent; anchors.margins: 24

//             ColumnLayout {
//                 anchors.top: parent.top; anchors.left: parent.left; spacing: 4
//                 Text { text: weatherCity; font.pixelSize: 24; font.weight: Font.Bold; color: "white" }
//                 Text { text: weatherDate; font.pixelSize: 14; color: "#EBEBF5"; opacity: 0.6 }
//             }

//             Item {
//                 anchors.right: parent.right; anchors.top: parent.top
//                 anchors.topMargin: activeWidget === 3 ? 40 : 10
//                 width: activeWidget === 3 ? 160 : 80; height: width
//                 Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

//                 Image {
//                     source: weatherIconPath; anchors.centerIn: parent
//                     width: parent.width * 0.8; height: width
//                     fillMode: Image.PreserveAspectFit; visible: status === Image.Ready
//                 }
//                 Text {
//                     text: "⛅"; font.pixelSize: parent.width * 0.8; anchors.centerIn: parent
//                     visible: !parent.children[0].visible
//                 }
//             }

//             ColumnLayout {
//                 anchors.bottom: parent.bottom; anchors.left: parent.left; spacing: -4
//                 Text {
//                     text: weatherTemp; font.pixelSize: activeWidget === 3 ? 96 : 64
//                     font.weight: Font.Light; color: "white"
//                     Behavior on font.pixelSize { NumberAnimation { duration: 400; easing.type: Easing.InOutQuart } }
//                 }
//                 Text { text: weatherCondition + " • " + weatherHighLow; font.pixelSize: 16; color: "#EBEBF5"; opacity: 0.6 }
//             }
//         }
//     }
// }

import QtQuick 2.9
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

// import Style 1.0

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

    // ==========================================
    // 接口：播放器核心状态 (对接 C++ QMediaPlayer)
    // ==========================================
    property bool musicIsPlaying: false
    property int currentSongIndex: 0

    // 时间状态 (单位：秒)
    property int musicDurationSec: 200
    property int musicElapsedSec: 0

    // 根据秒数自动计算进度 (0.0 - 1.0)
    property real musicProgress: musicDurationSec > 0 ? (musicElapsedSec / musicDurationSec) : 0

    // 当前曲目信息
    property string musicTitle: ""
    property string musicArtist: ""
    property string musicCoverPath: ""

    // 天气接口预留
    property string weatherCity: "Cupertino"
    property string weatherDate: "Tuesday, March 24"
    property string weatherTemp: "22°"
    property string weatherCondition: "Partly Cloudy"
    property string weatherHighLow: "H:26° L:14°"
    property string weatherIconPath: "qrc:/icons/weather_cloud.png"

    // ==========================================
    // 内部逻辑与工具函数
    // ==========================================

    // 时间格式化函数 (例如把 130 变成 "2:10")
    function formatTime(seconds) {
        var m = Math.floor(seconds / 60);
        var s = Math.floor(seconds % 60);
        return m + ":" + (s < 10 ? "0" : "") + s;
    }

    // 切歌函数
    function playSong(index) {
        if (index < 0 || index >= playlistModel.count)
            return;
        var songData = playlistModel.get(index);

        currentSongIndex = index;
        musicTitle = songData.songName;
        musicArtist = songData.artistName;
        musicCoverPath = songData.coverImg;
        musicDurationSec = songData.durationSec;
        musicElapsedSec = 0;
        musicIsPlaying = true;
    }

    // 模拟后台播放的定时器 (C++ 接入后可删除)
    Timer {
        id: mockPlaybackTimer
        interval: 1000
        running: musicIsPlaying && activeWidget !== -1 // 只要在播放就跑
        repeat: true
        onTriggered: {
            if (musicElapsedSec < musicDurationSec) {
                musicElapsedSec++;
            } else {
                // 播完了自动下一首
                var nextIndex = (currentSongIndex + 1) % playlistModel.count;
                playSong(nextIndex);
            }
        }
    }

    // 初始化时加载第一首歌
    Component.onCompleted: {
        playSong(0);
        musicIsPlaying = false; // 初始不自动播放
    }

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
                text: activeWidget === 1 ? "↙" : "↗"
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
    }

    // ----------------------
    // 2. 音乐模块
    // ----------------------
    Rectangle {
        id: musicWidgetContainer
        color: cardBackgroundColor
        radius: 16
        border.color: cardBorderColor
        border.width: 1
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

        Behavior on anchors.rightMargin {
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

        MouseArea {
            anchors.fill: parent
            z: 0
            onClicked: activeWidget = activeWidget === 0 ? 2 : 0
        }

        // ==========================================
        // 迷你模式 UI
        // ==========================================
        Item {
            anchors.fill: parent
            anchors.margins: 16
            opacity: activeWidget === 2 ? 0 : 1
            visible: opacity > 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 16
                Rectangle {
                    width: bottomWidgetHeight - 32
                    height: width
                    radius: 10
                    color: "#2C2C2E"
                    clip: true
                    Image {
                        anchors.fill: parent
                        source: musicCoverPath
                        fillMode: Image.PreserveAspectCrop
                        visible: status === Image.Ready
                    }
                    Text {
                        text: "🎵"
                        color: "#8E8E93"
                        font.pixelSize: 32
                        anchors.centerIn: parent
                        visible: !parent.children[0].visible
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 4
                    Text {
                        text: musicTitle
                        font.pixelSize: 20
                        font.weight: Font.DemiBold
                        color: "#FFFFFF"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: musicArtist
                        font.pixelSize: 16
                        color: "#8E8E93"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                RowLayout {
                    spacing: 16
                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: musicIsPlaying ? "#3A3A3C" : "#FFFFFF"
                        Image {
                            source: musicIsPlaying ? "qrc:/icons/pause_black.png" : "qrc:/icons/play_black.png"
                            anchors.centerIn: parent
                            width: 20
                            height: 20
                            fillMode: Image.PreserveAspectFit
                            visible: status === Image.Ready
                        }
                        Text {
                            text: musicIsPlaying ? "⏸" : "▶"
                            color: musicIsPlaying ? "white" : "black"
                            font.pixelSize: 20
                            anchors.centerIn: parent
                            visible: !parent.children[0].visible
                            anchors.horizontalCenterOffset: musicIsPlaying ? 0 : 2
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                musicIsPlaying = !musicIsPlaying;
                                mouse.accepted = true;
                            }
                            onPressed: parent.scale = 0.9
                            onReleased: parent.scale = 1.0
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 100
                                }
                            }
                        }
                    }
                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: "transparent"
                        Image {
                            source: "qrc:/icons/next_white.png"
                            anchors.centerIn: parent
                            width: 24
                            height: 24
                            fillMode: Image.PreserveAspectFit
                            visible: status === Image.Ready
                        }
                        Text {
                            text: "⏭"
                            color: "#FFFFFF"
                            font.pixelSize: 24
                            anchors.centerIn: parent
                            visible: !parent.children[0].visible
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                playSong((currentSongIndex + 1) % playlistModel.count);
                                mouse.accepted = true;
                            }
                            onPressed: parent.opacity = 0.5
                            onReleased: parent.opacity = 1.0
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 100
                                }
                            }
                        }
                    }
                }
            }
            // 底部迷你进度条
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 3
                radius: 1.5
                color: "#3A3A3C"
                Rectangle {
                    width: parent.width * musicProgress
                    height: parent.height
                    radius: 1.5
                    color: "#FFFFFF"
                }
            }
        }

        // ==========================================
        // 全屏模式 UI
        // ==========================================
        Item {
            anchors.fill: parent
            opacity: activeWidget === 2 ? 1 : 0
            visible: opacity > 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            // ---------------- 左侧主控区 ----------------
            Item {
                width: parent.width * 0.55
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 40
                    spacing: 20

                    // 1. 封面
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Rectangle {
                            id: coverRect
                            width: Math.min(parent.width, parent.height)
                            height: width
                            anchors.centerIn: parent
                            radius: 16
                            color: "#2C2C2E"
                            Image {
                                id: fullCoverImg
                                anchors.fill: parent
                                anchors.margins: 1
                                source: musicCoverPath
                                fillMode: Image.PreserveAspectCrop
                                visible: status === Image.Ready
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: coverRect.width
                                        height: coverRect.height
                                        radius: 15
                                    }
                                }
                            }
                            Text {
                                text: "🎵"
                                color: "#555"
                                font.pixelSize: coverRect.width * 0.4
                                anchors.centerIn: parent
                                visible: !fullCoverImg.visible
                            }
                        }
                    }

                    // 2. 信息
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            Text {
                                text: musicTitle
                                font.pixelSize: 28
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Text {
                                text: musicArtist
                                font.pixelSize: 20
                                color: themeColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                        Rectangle {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            radius: 16
                            color: "#3A3A3C"
                            Text {
                                text: "•••"
                                color: "white"
                                font.pixelSize: 14
                                anchors.centerIn: parent
                                anchors.verticalCenterOffset: -2
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse.accepted = true
                                onPressed: parent.opacity = 0.6
                                onReleased: parent.opacity = 1.0
                            }
                        }
                    }

                    // 3. 进度条 (已实现数据绑定和拖动修改时间)
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        spacing: 8
                        Slider {
                            id: fullSlider
                            Layout.fillWidth: true
                            Layout.preferredHeight: 24
                            from: 0
                            to: 100
                            value: musicProgress * 100

                            // 拖动时同步修改播放秒数
                            onMoved: {
                                musicElapsedSec = (value / 100) * musicDurationSec;
                            }

                            background: Rectangle {
                                y: parent.height / 2 - height / 2
                                width: parent.width
                                height: 6
                                radius: 3
                                color: "#3A3A3C"
                                Rectangle {
                                    width: parent.visualPosition * parent.width
                                    height: parent.height
                                    color: themeColor
                                    radius: 3
                                }
                            }
                            handle: Rectangle {
                                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                width: fullSlider.pressed ? 20 : 8
                                height: width
                                radius: width / 2
                                color: "#FFFFFF"
                                Behavior on width {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            // 当前时间
                            Text {
                                text: formatTime(musicElapsedSec)
                                color: "#8E8E93"
                                font.pixelSize: 13
                                font.weight: Font.DemiBold
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            // 剩余时间 (以负号显示)
                            Text {
                                text: "-" + formatTime(musicDurationSec - musicElapsedSec)
                                color: "#8E8E93"
                                font.pixelSize: 13
                                font.weight: Font.DemiBold
                            }
                        }
                    }

                    // 4. 控制盘
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10
                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            opacity: 0.8
                            Text {
                                text: "🔀"
                                color: "#FFFFFF"
                                font.pixelSize: 20
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse.accepted = true
                                onPressed: parent.opacity = 0.4
                                onReleased: parent.opacity = 0.8
                            }
                        }
                        Item {
                            Layout.preferredWidth: 20
                        }
                        Item {
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            Text {
                                text: "⏮"
                                color: "#FFFFFF"
                                font.pixelSize: 32
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var prevIndex = currentSongIndex - 1 < 0 ? playlistModel.count - 1 : currentSongIndex - 1;
                                    playSong(prevIndex);
                                    mouse.accepted = true;
                                }
                            }
                        }
                        Item {
                            Layout.preferredWidth: 10
                        }
                        Rectangle {
                            Layout.preferredWidth: 72
                            Layout.preferredHeight: 72
                            radius: 36
                            color: musicIsPlaying ? "#3A3A3C" : "#FFFFFF"
                            Text {
                                text: musicIsPlaying ? "⏸" : "▶"
                                color: musicIsPlaying ? "white" : "black"
                                font.pixelSize: 32
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: musicIsPlaying ? 0 : 4
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    musicIsPlaying = !musicIsPlaying;
                                    mouse.accepted = true;
                                }
                                onPressed: parent.scale = 0.9
                                onReleased: parent.scale = 1.0
                                Behavior on scale {
                                    NumberAnimation {
                                        duration: 100
                                    }
                                }
                            }
                        }
                        Item {
                            Layout.preferredWidth: 10
                        }
                        Item {
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            Text {
                                text: "⏭"
                                color: "#FFFFFF"
                                font.pixelSize: 32
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    playSong((currentSongIndex + 1) % playlistModel.count);
                                    mouse.accepted = true;
                                }
                            }
                        }
                        Item {
                            Layout.preferredWidth: 20
                        }
                        Item {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            opacity: 0.8
                            Text {
                                text: "🔁"
                                color: "#FFFFFF"
                                font.pixelSize: 20
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse.accepted = true
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // ---------------- 右侧列表区 ----------------
            Item {
                anchors.left: parent.children[0].right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 40

                Text {
                    id: listHeaderTitle
                    text: "待播清单"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: "white"
                    anchors.top: parent.top
                }

                // 包含歌曲信息的 ListModel，增加了时长字段
                ListModel {
                    id: playlistModel
                    ListElement {
                        songName: "Starboy"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list1.jpg"
                        durationSec: 230
                    }
                    ListElement {
                        songName: "Save Your Tears"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list2.jpg"
                        durationSec: 215
                    }
                    ListElement {
                        songName: "Die For You"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list3.jpg"
                        durationSec: 260
                    }
                    ListElement {
                        songName: "Out of Time"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list4.jpg"
                        durationSec: 214
                    }
                    ListElement {
                        songName: "Less Than Zero"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list5.jpg"
                        durationSec: 211
                    }
                }

                ListView {
                    anchors.top: listHeaderTitle.bottom
                    anchors.topMargin: 24
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    clip: true
                    spacing: 8
                    model: playlistModel
                    delegate: Rectangle {
                        width: parent.width
                        height: 60
                        radius: 10

                        // 当前播放的歌曲底色微亮
                        property bool isCurrent: index === currentSongIndex
                        color: isCurrent ? "#2C2C2E" : (itemMouseArea.pressed ? "#3A3A3C" : "transparent")
                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 16

                            // 左侧封面 or 动画占位
                            Rectangle {
                                Layout.preferredWidth: 44
                                Layout.preferredHeight: 44
                                radius: 6
                                color: "#2C2C2E"
                                clip: true

                                // 封面图
                                Image {
                                    source: coverImg
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectCrop
                                    visible: status === Image.Ready
                                    opacity: isCurrent ? 0.4 : 1.0 // 播放时封面变暗，凸显上面的图标
                                }

                                // 正在播放的特效 (简单文字模拟声波，可用 Lottie 替代)
                                Text {
                                    text: "ılıılı"
                                    color: "white"
                                    font.pixelSize: 16
                                    font.weight: Font.Bold
                                    anchors.centerIn: parent
                                    visible: isCurrent && musicIsPlaying
                                }
                                Text {
                                    text: "⏸"
                                    color: "white"
                                    font.pixelSize: 16
                                    anchors.centerIn: parent
                                    visible: isCurrent && !musicIsPlaying
                                }
                            }

                            // 居中严格对齐的文字信息
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text {
                                    text: songName
                                    color: isCurrent ? themeColor : "#FFFFFF" // 播放中显示主题色(粉色)
                                    font.pixelSize: 16
                                    font.weight: isCurrent ? Font.Bold : Font.Medium
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: artistName
                                    color: "#8E8E93"
                                    font.pixelSize: 14
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            // 右侧时间/拖动占位
                            Text {
                                text: formatTime(durationSec)
                                color: "#8E8E93"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        MouseArea {
                            id: itemMouseArea
                            anchors.fill: parent
                            onClicked: {
                                if (currentSongIndex === index) {
                                    musicIsPlaying = !musicIsPlaying; // 点击正在播放的歌曲则暂停/继续
                                } else {
                                    playSong(index); // 点击其他歌曲直接切换
                                }
                                mouse.accepted = true;
                            }
                        }
                    }
                }
            }
        }
    }

    // ----------------------
    // 3. 天气模块 (保持不变)
    // ----------------------
    Rectangle {
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
            onClicked: activeWidget = activeWidget === 0 ? 3 : 0
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
}
